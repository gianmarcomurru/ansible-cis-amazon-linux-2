#!/bin/bash

# users=$(yq  -r '.sudoers[].name' defaults/users.yml)
users=$(python3 -c 'from update_yaml import names; names()')

# Loop through each name in the sudoers list
for name in $users; do
  echo "------------------------------------- $name --------------------------------------"
  echo "Min 14 Characters, it must contain Uppercase, Lowercase, Number, Special Character"
  passwd $name
  
  # Retrieve hashed password and last change from /etc/shadow
  shadow_info=$(grep "$name" /etc/shadow)
  hashed_password=$(echo $shadow_info | awk -F: '{print $2}')
  last_change=$(echo $shadow_info | awk -F: '{print $3}')

  echo -e "\n\tHashed password: $hashed_password"
  echo -e "\tLast change: $last_change\n"
  python3 update_yaml.py $name $hashed_password $last_change
done

echo "------------------------------------- Done --------------------------------------"