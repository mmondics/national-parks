sudo dnf install python3 redhat-rpm-config gcc libffi-devel python3-devel openssl-devel cargo pkg-config -y
python3 -m pip3 install cryptography --no-binary --ignore-installed cryptography
python3 -m pip3 install ansible kubernetes jsonpatch PyYAML --ignore-installed
ansible-galaxy collection install kubernetes.core
ansible-playbook yaml/ansible/deploy.yaml