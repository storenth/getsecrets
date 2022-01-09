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
LOCALHOST="(localhost|127\.0\.0\.1|mysql|postgres).{0,32}"
# [[:blank:]] need to avoid `grep: parentheses not balanced` issue
PRIVATEKEY="(-----BEGIN[[:blank:]]OPENSSH[[:blank:]]PRIVATE[[:blank:]]KEY-----|-----BEGIN[[:blank:]]RSA[[:blank:]]PRIVATE[[:blank:]]KEY-----|-----BEGIN[[:blank:]]DSA[[:blank:]]PRIVATE[[:blank:]]KEY-----|-----BEGIN[[:blank:]]EC[[:blank:]]PRIVATE[[:blank:]]KEY-----|-----BEGIN[[:blank:]]PGP[[:blank:]]PRIVATE[[:blank:]]KEY[[:blank:]]BLOCK-----).{0,32}"
GITHUBTOKEN="(ghp_|ghu_|ghs_|ghr_|gho_)([[:alnum:]_-]){35,}"
JSONWEBTOKEN="ey([[:alnum:]_=-])+[.]([[:alnum:]_=-])+[.]?([[:alnum:]_=.+/-])+"
PASSWORD="(password|admin|login|pwd|root|administrator|adminer|test|user|developer|dev|adm|psswd)([\"[:blank:]])?[[:blank:]]?[:=][[:blank:]]?([\"[:blank:]])?([[:alnum:][:punct:]]){3,32}"

# get js and parse for secrets
getsecrets(){
  SECRETS=$($CURLREQUEST ${1} | grep -ioE -e $APITOKEN -e $S3ENDPOINT -e $S3TARGET -e $BASICAUTH -e $BEARERTOKEN -e $LOCALHOST -e $PRIVATEKEY -e $GITHUBTOKEN -e $JSONWEBTOKEN -e $PASSWORD)
  echo "[+] ${1}"
  echo "${SECRETS}"
  echo
}

# path fuzzing
getsecrets "$1"
