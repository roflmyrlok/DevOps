#!/bin/bash

FILE="addressbook.txt"

#program asks user for name, phone number, email and save this info to a file.
add(){
    echo "Enter name: "
    read name
    echo "Enter phone number: "
    read phone
    echo "Enter email: "
    read email
    echo "$name|$phone|$email" >> "$FILE"
    echo "Added"
}

_internal_search(){
    local search_text="$1"
    local exact_match="$2"
    
    if [ "$exact_match" == "true" ]; then
        grep -w -i "$search_text" "$FILE"
    else
        grep -i "$search_text" "$FILE"
    fi
}

#program allows searching for users. You can enter any text to search
search(){
    echo "Enter search text: "
    read search_text
    matches=$(internal_search "$search_text" false)

    if [ -z "$matches" ]; then
        echo "No contact found"
    else
        echo "Found contacts: "
        echo "$matches"
    fi
}

#program removes the user if it finds him by name or phone number or email.
remove(){
    echo "Enter exact name or phone number or email to remove: "
    read search_text
    search_result=$(_internal_search "$search_text" true)

    if [ -z "$search_result" ]; then
        echo "No matching contact found"
        return
    fi

    echo "Search result: "
    echo "$search_result"

    echo "Confirm remove (y/n)"
    read confirmation
    
    if [ "$confirmation" == "y" ]; then
        grep -v -F "$search_result" "$FILE" > temp_file && mv temp_file "$FILE"
        echo "Removed"
    else
        echo "Canceled"
    fi
}

case "$1" in
    add)
        add
        ;;
    search)
        search
        ;;
    remove)
        remove
        ;;
  *)
    echo "Usage: $0 {add|search|remove}"
    ;;
esac
