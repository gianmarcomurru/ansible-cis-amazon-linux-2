#!/bin/bash
passing=""
grep -Eiq '^\s*UMASK\s+(0[0-7][2-7]7|[0-7][2-7]7)\b' /etc/login.defs && \
grep -Eqi '^\s*USERGROUPS_ENAB\s*"?no"?\b' /etc/login.defs && \
grep -Eqs '^\s*session\s+(optional|requisite|required)\s+pam_umask\.so\b' /etc/pam.d/common-session && \
passing=true
grep -REiq '^\s*UMASK\s+\s*(0[0-7][2-7]7|[0-7][2-7]7|u=(r?|w?|x?)(r?|w?|x?)(r?|w?|x?),g=(r?x?|x?r?),o=)\b' /etc/profile* /etc/bashrc* && passing=true
[ "$passing" = true ] && 
if [ "$passing" = true ]
then
    echo "Default user umask is set"
    exit 0
else
    exit 1
fi