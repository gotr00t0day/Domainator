from sub_output import scan
from colorama import Fore
import sys
import socket
import whois


target = sys.argv[1]

def domain_info(domain: str) -> str:
    scan(f"./scripts/crt.sh {domain} >> domains.txt")
    with open("domains.txt", "r") as f:
        domain_list = [x.strip() for x in f.readlines()]
        for domains in domain_list:
            try:
               ips = socket.gethostbyname(domains)
               w = whois.whois(domains)
               for k, v in w.items():
                   if "org" in k:
                       if v == None:
                           pass
                       else:
                           print(f"{Fore.BLUE}{v}\n")
               ip_ranges = scan(f"./asnmap -i {ips} -silent")
               print(f"{Fore.GREEN}{domains}: {Fore.CYAN}{ips}\n{Fore.MAGENTA}{ip_ranges}")
            except socket.gaierror:
                pass

            
if __name__ == "__main__":
    domain_info(target)
