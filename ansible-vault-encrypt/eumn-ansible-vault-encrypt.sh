#!/bin/bash
set -e

echo "-----------------------------------------------------------------"
echo "Encrypt string with Ansible-Vault for you ~"
echo -ne "\n* Usage: './eumn-ansible-vault-encrypt.sh {vault-password-file}"
echo -ne "\n* Param: '--encrypt-first' (for Ansible User Module password)\n"
echo "-----------------------------------------------------------------"
sleep 1

#check vault-password-file in arguments.
if [ -z "$1" ]; then
    echo -e "ERROR : {vault-password-file} path not provided." >&2
    exit 1
fi

#Check {vault-password-file} file
password_file="$1"
if [ ! -f $password_file ]; then
  echo -e "ERROR : vault-password-file: ${password_file} not found." >&2
  exit 1
fi

read -s -p "enter string to encrypt: " secret_string
echo -e "\n"

## Encrypt the string first, used for User Module password
if [ "$2" == "--encrypt-first" ]; then
  echo "INFO : encrypt first with sha512 ..."
  secret_salt=$(<${password_file})
  secret_string=$(ansible all -i localhost, -m debug -a "msg={{ '${secret_string}' | password_hash('sha512', '${secret_salt}') }}" \
                    | awk -F\" '{print $4}' )
fi

echo -e "INFO : encrypting using ansible-vault ...\n"
ansible-vault encrypt_string --vault-password-file ${password_file} ${secret_string} --name 'your_ansible_secret'
