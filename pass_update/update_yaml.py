import sys
import ruamel.yaml
from datetime import date

def main():
    if len(sys.argv) != 4:
        print("Usage: python3 update_yaml.py <name> <hashed_password> <last_password_change>")
        exit(1)

    name = sys.argv[1]
    hashed_password = sys.argv[2]
    last_password_change = sys.argv[3]

    yaml = ruamel.yaml.YAML()
    yaml.preserve_quotes = True


    with open("defaults/users.yml") as f:
        yml = yaml.load(f)

    for sudoer in yml["sudoers"]:
        if sudoer["name"] == name:
            sudoer["password"] = hashed_password
            sudoer["password_last_change"] = last_password_change
            sudoer.yaml_add_eol_comment(f"Changed on {date.today().strftime('%B %d, %Y')}", "name", column=0)
            break

    choice = input("Do you want to save the changes? Y/N: ")
    if choice == "Y" or choice == "y" or choice == "":
        with open("defaults/users.yml", "w") as f:
            yaml.dump(yml, f)
    else:
        print("Changes not saved.")

def names():
    yaml = ruamel.yaml.YAML()
    yaml.preserve_quotes = True


    with open("defaults/users.yml") as f:
        yml = yaml.load(f)

    for sudoers in yml["sudoers"]:
        print(sudoers["name"])

if __name__ == "__main__":
    main()