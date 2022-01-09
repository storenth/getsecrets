#! /bin/bash

# definitions
checkhelp(){
  echo "./getsecret.sh https://target.com/path/file.js"
  exit 0
}

if [ $# -eq 0 ]; then
  checkhelp "$@" 
fi

# alias
CURLREQUEST='curl -k -s --max-time 10'

# regex
APITOKEN="(api[[:blank:]._-]?)?token([\"[:blank:]]+)?[:=]([\"[:blank:]]+)?([[:alnum:]]){5,}[.]?.{0,32}"
S3ENDPOINT="(https?://)?(w{3}.)?(([[:alnum:].-]+)+)?(s3|amazon|bucket|aws)(([[:alnum:].-]+)+)[.][[:alpha:]]{2,4}.{0,32}"
S3TARGET="s3://(([[:alnum:].-]+)+)?(([[:alnum:].-]+)+).{0,32}"
BASICAUTH="basic[[:blank:]._-]?auth([\"[:blank:]]+)?([:=])([\"[:blank:]]+)?([[:alnum:]]){5,}[.]?.{0,32}"
BEARERTOKEN="bearer[\"[:blank:]._-]?([[:blank:]=]+)?[\"]?([[:alnum:]]){5,}.{0,32}"


# get js and parse for secrets
getsecrets(){
  SECRETS=$($CURLREQUEST ${1} | grep -ioE -e $APITOKEN -e $S3ENDPOINT -e $S3TARGET -e $BASICAUTH -e $BEARERTOKEN)
  echo "[+] ${1}"
  echo "${SECRETS}"
  echo
}

# path fuzzing
getsecrets "$1"
