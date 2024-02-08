# National Parks Sample OpenShift Application
 
The purpose of this repository is to get a sample microservices application comprised of a frontend, a backend, and a database up and running as quickly as possible. Once installed, this sample application can then be used to demonstrate any specific feature/function of OpenShift. 

This repository and application are based on the Red Hat OpenShift sample application - Parksmap. Parksmap is a microservices application that displays the location of National Parks on a map.

This application is made up of a frontend with source code [here](https://github.com/openshift-roadshow/parksmap-web), and a backend with source code [here](https://github.com/openshift-roadshow/nationalparks-py). Detailed instructions with steps to deploy this application via the OpenShift web console can be found [here](https://docs.openshift.com/container-platform/4.10/getting_started/openshift-web-console.html) or via the OpenShift CLI [here](https://docs.openshift.com/container-platform/4.10/getting_started/openshift-cli.html). The YAML files in this repository are simply a snapshot of the application after completing one of these two sets of instructions for ease of deployment with a single `oc create` command.

- [National Parks Sample OpenShift Application](#national-parks-sample-openshift-application)
  - [Requirements](#requirements)
  - [Procedure](#procedure)
  - [Notable Changes from Source Repositories](#notable-changes-from-source-repositories)
  - [Tested Platforms](#tested-platforms)
  - [Troubleshooting](#troubleshooting)
    - [Cannot create a new project](#cannot-create-a-new-project)
    - [Cannot access the Parksmap application in step 4](#cannot-access-the-parksmap-application-in-step-4)
    - [I messed up somewhere. Can I delete everything and try again?](#i-messed-up-somewhere-can-i-delete-everything-and-try-again)
    - [I don't have access to the `oc` CLI / I don't know how to use the `oc` CLI](#i-dont-have-access-to-the-oc-cli--i-dont-know-how-to-use-the-oc-cli)

## Requirements
1. OpenShift cluster (amd64, ppc64le, or s390x)
2. Ability to create a new project in OpenShift
3. Access to the OpenShift command line interface (CLI) or web console

## Procedure
- This document will walk you through a manual deployment below, following a step-by-step procedure. 
- If you instead would like to deploy the application via web console or via automation:
    - Alternate Methods:
        - Web console, see the [Troubleshooting Section](#i-dont-have-access-to-the-oc-cli--i-dont-know-how-to-use-the-oc-cli) below.
        - If you want to use an Ansible-automated deployment, see the [instructions](#automate-the-deployment-for-me) below:


1. Create a new project in OpenShift, for example `national-parks`

    ```text
    oc new-project national-parks
    ```

2. Deploy the full application (combined frontend and backend)

    ```text
    oc create -f https://raw.githubusercontent.com/mmondics/national-parks/main/yaml/combined/national-parks-combined.yaml
    ```

3. Load the backend database with data.

    ```text
    oc exec $(oc get pods -l component=nationalparks | tail -n 1 | awk '{print $1;}') -- curl -s http://localhost:8080/ws/data/load
    ```

    Note: you should see `"Items inserted in database: 204"` if you did everything right.

4. Navigate to your `parksmap` route in a web browser. 
   
   You can print the URL with the command.

    ```text
    echo "http://$(oc get route parksmap -n national-parks -o=jsonpath='{.spec.host}')"
    ```
  
You should now see the National Parks map with US locations loaded.

![national-parks-loaded-home](https://raw.githubusercontent.com/mmondics/media/main/images/national-parks-loaded-home.png)

## Notable Changes from Source Repositories
Some notable changes from the source repositories include:
- Rebuilt container images to be multiarchitecture (amd64, s390x, ppc64le) rather than solely amd64
  - See [Tested Platforms section](#tested-platforms)
- Added new default layer "Outdoors" that is more relevant to a National Parks map
- Added links to relevant National Parks Service website in each location marker
- Added smooth zoom when clicking on map or marker
- Added zoom in/out and "home" buttons to map legend
- Centered map to USA locations
- Included USA parks only (feel free to submit a pull request adding more locations to [nationalparks.json](/source/nationalparks-py/nationalparks.json). You can use [nationalparks-all.json](/source/nationalparks-py/nationalparks-all.json) as a source, adding in appropriate links.)


## Tested Platforms
- amd64
  - includes OCP local
- s390x
  - includes OCP on zCX
- ppc64le
  
## Troubleshooting

### Cannot create a new project

If your OpenShift credential does not have the required role to create a new project, you can use any existing project that you have access to. However, you will need to modify the commands above to reflect the new project name.

If you cannot create a new project and you do not have an existing project, you should reach out to your OpenShift cluster administrator to provide this for you.

### Cannot access the Parksmap application in step 4

Check the status of the pods in the national-parks project: `oc get pods -n national-parks`. All 3 pods should be running and say 1/1 are ready.

```text
NAME                                     READY   STATUS    RESTARTS   AGE
mongodb-nationalparks-569d8f967b-vkkgp   1/1     Running   0          72m
nationalparks-6f4b8858d5-wfns2           1/1     Running   0          72m
parksmap-84c87669d7-pf8ps                1/1     Running   0          72m
```

If any pods are not in this state, you need to investigate and find the source of the error. Some helpful commands will be: 

```text
oc get events -n national-parks
```

```text
oc logs <POD_NAME> -n national-parks
```

Where you replace `<POD_NAME>` with the name of the pod showing errors from `oc get pods -n national-parks`.

### I messed up somewhere. Can I delete everything and try again?

Yes, delete the `national-parks` project, wait a few minutes for the objects to be deleted, then start over from step 1 of the [procedure](#procedure).

```text
oc delete project national-parks
```

### I don't have access to the `oc` CLI / I don't know how to use the `oc` CLI

You can deploy this application via the OpenShift web console.

1. Create a new project: Administrator -> Home -> Projects -> New Project

    ![ocp-new-project](https://raw.githubusercontent.com/mmondics/media/main/images/ocp-new-project.png)

2. Open the Import Yaml page by clicking the button in the top bar of the OpenShift console. 

    ![ocp-import-yaml](https://raw.githubusercontent.com/mmondics/media/main/images/ocp-import-yaml.png)

3. Double check that you are in the national-parks project and change into it from the dropdown menu if you are not. 

    ![ocp-import-yaml-project](https://raw.githubusercontent.com/mmondics/media/main/images/ocp-import-yaml-project.png)

4. Paste the contents of [national-parks-combined.yaml](/yaml/combined/national-parks-combined.yaml) into the Import Yaml page and click Create.

5. Navigate to the Developer Topology page (Developer -> Topology)

    ![ocp-national-parks-topology](https://raw.githubusercontent.com/mmondics/media/main/images/ocp-national-parks-topology.png)

6. Click the link button associated with the `national-parks` icon

    ![ocp-national-parks-topology-focus](https://raw.githubusercontent.com/mmondics/media/main/images/ocp-national-parks-topology-focus.png)

7. In the URL for the new page that opens in your browser, add `/ws/data/load` to the end (e.g. `http://nationalparks-national-parks.apps.example.com/ws/data/load`)

    You should see `Welcome to the National Parks data service.` returned in the web browser. 

8. Back in the Topology Page, click the link associated with the `parksmap` icon

    ![ocp-national-parks-topology-focus-2](https://raw.githubusercontent.com/mmondics/media/main/images/ocp-national-parks-topology-focus-2.png)

You should now see the National Parks map with US locations loaded.

![national-parks-loaded-home](https://raw.githubusercontent.com/mmondics/media/main/images/national-parks-loaded-home.png)

### Automate the deployment for me
- Open a command-line prompt and SSH to your cluster's bastion server. 
- For example on a Mac/Linux machine that would look like this:
```
ssh <username>@<ip-address>
```
- It will ask you for a password, type it in and hit Enter. 
- Then, execute the following command:
```
sudo dnf install git -y && git clone https://github.com/mmondics/national-parks.git && cd national-parks && sh deploy.sh
```
- The instructions at the end of the process will tell you how to display your application.