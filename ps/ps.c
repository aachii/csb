/*
Filename:	ps.c
Author:		Janick Stucki
Date:		16.01.2019
Description:	Remake of the command "ps x -o pid,comm,rss"
Lists processes of your user ID with fields PID, NAME, VmRSS
*/

#include <stdio.h>
#include <dirent.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

int main() {
int pid_max; // variable for max pid count
DIR *d_proc; // read folders from /proc
struct dirent *dir; // used to read folders
FILE *f_pid; // variable for pid in loop
char pid_path[64]; // path to pid status file
char buff[64]; // buffer for status file
char pid_name[16]; // name
int pid_uid; // uid
char pid_vmrss[16]; // memory
int print = 0; // 1 is print, 0 is not

printf("%5s %-15.15s %5s\n", "PID", "COMMAND", "RSS"); // print table top

d_proc = opendir("/proc");
if (d_proc) {
	while ((dir = readdir(d_proc)) != NULL) {
		// dir->d_name loops through all files and folders
		print = 0; // default is to not print unless uid is correct
		sprintf(pid_path, "/proc/%d/status", dir->d_name); // build path to next status file
		if ((f_pid = fopen(pid_path, "r"))) { // open next status file
			while (fscanf(f_pid, "%15s", buff) != EOF) { // read word by word
				if (strstr(buff, "Name:")) { // if Name:
					fscanf(f_pid, "%15s", pid_name); // use next value as name
				} else if (strstr(buff, "Uid:")) { // if Uid:
					fscanf(f_pid, "%d", &pid_uid); // next value is user ID
					if (getuid() != pid_uid) { // check if current UID
						break; // if no break
					}
					print = 1; // set print to 1 if code passed if
				} else if (strstr(buff, "VmRSS:")) { // if VmRSS
					fscanf(f_pid, "%s", pid_vmrss); // use next value as RSS
				}
			}
			if (print == 1) { // print the line if print is 1
				printf("%5d %-15.15s %5s\n", pid, pid_name, pid_vmrss);
			}
			fclose(f_pid); // close the read status file
		}
	}
}
// return 0 at program end
return 0;
}
