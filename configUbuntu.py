#!/usr/bin/python

#Script to prepare a new machine with some software and configuration.

#Import functions

import os

#Variables
separator='..........########...........'


print ('Starting process...self.')
print separator

print ("Updating")
#Update
os.system("sudo apt-get update && sudo apt-get -y upgrade")

print ("Update finished")

print ("Starting alias config...")
os.system('alias ll="ls -la"')
os.system('alias osversion="cat /etc/*-release"')


print ("Installing...")
#Installing software.
os.system("sudo apt-get install -y openssh vsftpd git tmux")

#If it is a Desktop Computer we will install more software.
desktop = input("Is this a Desktop Computer? (y/n)")
if (desktop=="y"):
	print ("Installing additional software.")
	#Sublime text//Atom Editor
	os.system("sudo apt-get install -y sublime-text atom-editor")


print ("End installation")

#Configuration
print ("Starting Configuration")

#Hostname
print ("Changing Hostname")
hostname = input("What is the computer name?")

try:
	hostnameFile = open("/etc/hostname", "w")
	hostnameFile.truncate()
	hostnameFile.write(hostname)
	hostnameFile.close()
	print ("Hostname changed")
except IOError:
	print ("An error ocurred while hostname change.")

#SSH Config
print("Changing SSH configuration")
newSshPort = input("Whats the new port for SSH?")
path_ssh = "/etc/ssh/"
os.chdir(path_ssh)
modline("sshd_config", "sshd_config_new", "Port 22", newSshPort)
print ("Remember to modify the router configuration.")
print ("SSH Configuration changed.")


print separator
print ('....End process')



#Functions
def modLine(oldFile, newFile, oldWord, newWord):
	try:
		with open(oldFile, 'r') as input_file, open(newFile, 'w') as output_file:
	    for line in input_file:
	        if line.strip() == oldWord:
	            output_file.write(newWord'\n')
	        else:
	            output_file.write(line)
	except IOError:
		print ("Error modificating line.")
    return
