#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

int main() {
	int pid_max; // variable for max pid count
	FILE *f_pid_max; // read pid_max from file
	FILE *f_pid; // variable for pid in loop
	char pid_path[64]; // for path to pid status file
	char buff[64]; // buffer for status file
	char pid_name[16]; // name
	int pid_uid; // uid
	char pid_vmrss[16]; // memory
	int print = 0; // 1 is print, 0 is not
	f_pid_max = fopen("/proc/sys/kernel/pid_max", "r");
	fscanf(f_pid_max, "%d", &pid_max);
	fclose(f_pid_max);
	printf("%5s %-15.15s %5s\n", "PID", "COMMAND", "RSS");

	// loop through all possible pids
	for (int pid=0; pid<=pid_max; pid++) {
		print = 0;
		sprintf(pid_path, "/proc/%d/status", pid);
		if (f_pid = fopen(pid_path, "r")) {
			while (fscanf(f_pid, "%s", buff) != EOF) {
				if (strstr(buff, "Name:")) {
					fscanf(f_pid, "%15s", pid_name);
				} else if (strstr(buff, "Uid:")) {
                                        fscanf(f_pid, "%d", &pid_uid);
					if (getuid() != pid_uid) {
						break;
					}
                                } else if (strstr(buff, "VmRSS:")) {
                                        fscanf(f_pid, "%s", pid_vmrss);
					print = 1;
				}
			}
			if (print == 1) {
				printf("%5d %-15.15s %5s\n", pid, pid_name, pid_vmrss);
			}
			fclose(f_pid);
		}
	}
	return 0;
}
