#!/usr/bin/env bash
echo -e "\n\033[36m>>>\033[35m Nuclei-automation script \033[m\n";
nuclei --update-templates --silent
echo -e "\033[33m[!] Enter domain names seperated by 'space' \033[m" 
read -p " ----->>>>>>>> " input
for i in ${input[@]}
do

echo -e "\n\033[36m>>>\033[35m Scan started for ./$i \033[m\n"
 
mkdir ./$i  

echo -e "\n\033[33m[!] Subfinder and Assetfinder Running..................\033[m"
subfinder -d $i -o ./$i/subdomains
assetfinder -subs-only $i | tee -a ./$i/subdomains
echo -e "\n\033[36m Total no. of unique subdomains found -->>\033[m"
sort -u ./$i/subdomains -o ./$i/subdomains
cat ./$i/subdomains | wc -l
echo -e "\n\033[33m[!] Subdomains saved at ./$i/subdomains\033[m"

echo -e "\n\033[36m>>>\033[35m Scan for CVES started\033[m\n"
nuclei -l ./$i/subdomains -t cves/ -o ./$i/cves
echo -e "\n\033[33m[!] Scan for CVES completed\033[m"
echo -e "\n\033[36m>>>\033[35m Scan for default-login started\033[m\n"
nuclei -l ./$i/subdomains -t default-logins/ -o ./$i/default-logins
echo -e "\n\033[33m[!] Scan for default-login completed\033[m"
echo -e "\n\033[36m>>>\033[35m Scan for exposures started\033[m\n"
nuclei -l ./$i/subdomains -t exposures/ -o ./$i/exposures
echo -e "\n\033[33m[!] Scan for exposures completed\033[m"
echo -e "\n\033[36m>>>\033[35m Scan for misconfigurations started\033[m\n"
nuclei -l ./$i/subdomains -t misconfiguration/ -o ./$i/misconfigurations
echo -e "\n\033[33m[!] Scan for misconfigurations completed\033[m"
echo -e "\n\033[36m>>>\033[35m Scan for takeovers started\033[m\n"
nuclei -l ./$i/subdomains -t takeovers/ -o ./$i/takeovers
echo -e "\n\033[33m[!] Scan for takeovers completed\033[m"
echo -e "\n\033[36m>>>\033[35m Scan for vulnerabilities started\033[m\n"
nuclei -l ./$i/subdomains -t vulnerabilities/ -o ./$i/vulnerabilities
echo -e "\n\033[33m[!] Scan for vulnerabilities completed\033[m"
echo -e "\n\033[36m>>>\033[35m
'
'
'
Scan finished for $i
\033[m\n"
done
