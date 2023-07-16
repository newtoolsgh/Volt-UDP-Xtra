import sys
import os
import pwd
import subprocess
from time import sleep
import pexpect
from datetime import datetime

action = sys.argv[1]
if action == "route":

  if len(sys.argv) < 4:
    print("Usage: route interface ports")  
    sys.exit(1)

  interface = sys.argv[2]
  ports_str = sys.argv[3]

  # Validate ports
  ports = ports_str.split(",")
  for port in ports:
    if not port.isdigit():
      print(f"Invalid port: {port}")
      sys.exit(1)

  ports = [int(port) for port in ports]
  ports = sorted(ports)

  start = 1
  for n in ports:
    if n == 1:
      start += 1
      continue

    cmd = f"iptables -t nat -I PREROUTING -i {interface} -p udp --dport {start}:{n-1} -j REDIRECT --to-ports 8989"
    os.system(cmd)

    start = n + 1

  if ports[-1] != 65535:
    cmd = f"iptables -t nat -I PREROUTING -i {interface} -p udp --dport {start}:65535 -j REDIRECT --to-ports 8989"
    os.system(cmd)

  print("IPTABLES Rules Added")

if action == "manage":
    #python3 manage.py manage add user password 2028-05-01
    if len(sys.argv) < 3:
        print("Action user is requerid")
        sys.exit(1)
    if sys.argv[2] == "add":
        if len(sys.argv) < 6:
            print("Requerid user pass and expire time format 2022-05-01")  
            sys.exit(1)
            
        os.system("docker exec -it udpr adduser "+sys.argv[3]+" --disabled-password")    
        os.system("docker exec -it udpr chage -E "+sys.argv[5]+" "+sys.argv[3])
        cmdChangePassword = "docker exec -it udpr sh /root/useradd.sh \""+sys.argv[3]+"\" \""+sys.argv[4]+"\""
        os.system(cmdChangePassword)
      
        print("User added")
    if sys.argv[2] == "del":
        if len(sys.argv) < 4:
            print("Error requerid username to delete")
            sys.exit(1)
        print("delete user = "+sys.argv[3])
        os.system("docker exec -it udpr userdel "+sys.argv[3])

if action == "online":

  result = subprocess.run(["docker", "exec", "-it", "udpr", "who"], capture_output=True)

  for line in result.stdout.decode().split("\n"):

    if line:
    
      parts = line.split()
      username = parts[0]
      
      # Get user info
      try:
        user_info = pwd.getpwnam(username)
        user_id = user_info.pw_uid
        
      except KeyError:
        continue
      
      # Skip if system user  
      if user_id < 1000:
        continue

      # Parse duration
      time_str = parts[2] + " " + parts[3]
      duration = datetime.strptime(time_str, "%H:%M")
      
      # Format duration
      seconds = duration.second
      minutes = duration.minute 
      hours = duration.hour
      duration_str = ""
      if hours > 0:
        duration_str += str(hours) + "h "
      if minutes > 0:
        duration_str += str(minutes) + "m "
      duration_str += str(seconds) + "s"
      
      print(f"{username} - Connected for {duration_str}")

if action == "detail":

  if len(sys.argv) < 3:
    print("Usage: detail <username>")
    sys.exit(1)
  
  username = sys.argv[2]

  try:
    result = subprocess.run(['docker', 'exec', '-it', 'udpr', 'who'], capture_output=True, text=True)
  except subprocess.CalledProcessError:
    print(f"Error getting details for user {username}")
    sys.exit(1)
  
  print(result.stdout)
