#include <stdio.h>
#include <string.h>

int main() {
	int pid_max; // variable for max pid count
	FILE *f_pid_max; // read pid_max from file
	FILE *f_pid; // variable for pid in loop
	char pid_path[64]; // for path to pid status file
	char buff[64]; // buffer for status fule
	char pid_name[64]; // name
	int pid_uid; // uid
	int pid_vmrss; // memory
	f_pid_max = fopen("/proc/sys/kernel/pid_max", "r");
	fscanf(f_pid_max, "%d", &pid_max);
	fclose(f_pid_max);
	//printf("Max pids: %d\n", pid_max);
	
	// loop through all possible pids
	for (int pid=0; pid<=pid_max; pid++) {
		sprintf(pid_path, "/proc/%d/status", pid);
		if (f_pid = fopen(pid_path, "r")) {
			while (fgets(buff, sizeof(buff), f_pid) != NULL) {
				buff[strlen(buff)-1] = '\0'; // remove newline at end
				if (strstr(buff, "Name")) {
					printf("%s\n", buff);
					//fscanf(f_pid, "Name: %s", pid_name);
				} else if (strstr(buff, "Uid")) {
					printf("%s\n", buff);
					//fscanf(f_pid, "Uid: %d ", &pid_uid);
				} else if (strstr(buff, "VmRSS")) {
					printf("%s\n", buff);
					//fscanf(f_pid, "VmRSS: %d ", &pid_vmrss);
				}
			}
			printf("%d %s %d %d\n", pid, pid_name, pid_uid, pid_vmrss);

			//printf("pid %d valid\n", pid);
			fclose(f_pid);
		}	
	}

	return 0;
}
