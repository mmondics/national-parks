sudo dnf install python3 -y
python3 -m pip install ansible
ansible-galaxy collection install kubernetes.core
ansible-playbook yaml/ansible/deploy.yaml