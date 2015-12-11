3-Hour Docker Workshop Training Prep
====================================

If you are in a classroom environment, you will be given two machines listed as `studentXYZa` and `studentXYZb` where `XYZ` is a number.

If you are doing this workshop on your own, you will need to deploy the hosts on your own. Download `rexconfig.yml`, `student.json`, and `dockertraining.sh` to a local folder.

Edit `rexconfig.yml` with your AWS ACCESS & SECRET KEYS. Edit `student.json` to make sure `rexconfig.yml` and `dockertraining.sh` are in an available directory.

The `docker-machine` AWS security group should have the following ports open

| Protocol | Port Range
| ---------|:----------:|
| TCP      | 3376       |
| TCP      | 80         |
| TCP      | 8080       |
| TCP      | 7946       |
| TCP      | 5000       |
| TCP      | 2376       |
| TCP      | 7946       |
| TCP      | 2375       |
| UDP      | 4789       |
| TCP      | 443        |
| TCP      | 8888       |
| TCP      | 22         |
| TCP      | 3375       |
| TCP      | 8500       |

Using [Docker Machine with the experimental EMC {code} extension framework](http://blog.emccode.com/2015/09/26/make-docker-machine-do-anything-with-our-experimental-extensions/) deploy a host. Each student needs 2 hosts.

Download this unsupported binary and make it executable (example for Mac OS X):
```
$ curl -L https://github.com/kacole2/machine/releases/download/v0.5.0-dev-ext/docker-machine_darwin-amd64 > /usr/local/bin/docker-machine
$ chmod +x /usr/local/bin/docker-machine
```

Use this binary to provision your hosts for the workshop:

#### For US-East-1 (default) (AMI using Ubuntu 14.04.03 with Kernel 3.19-30)
```
$ docker-machine -D create --driver amazonec2 --amazonec2-access-key <access-key> --amazonec2-secret-key <secret-key> --amazonec2-vpc-id <vpc-id> --amazonec2-zone "b" --amazonec2-ami ami-f6e6979c --engine-install-url "https://get.docker.com" --extension /Users/kcoleman/Desktop/student.json student001a

$ docker-machine -D create --driver amazonec2 --amazonec2-access-key <access-key> --amazonec2-secret-key <secret-key> --amazonec2-vpc-id <vpc-id> --amazonec2-zone "b" --amazonec2-ami ami-f6e6979c --engine-install-url "https://get.docker.com" --extension /Users/kcoleman/Desktop/student.json student001b
```

#### For EU-West-1 (AMI using Ubuntu 14.04.03 with Kernel 3.19-30)
```
$ docker-machine -D create --driver amazonec2 --amazonec2-access-key <access-key> --amazonec2-secret-key <secret-key> --amazonec2-region "eu-west-1" --amazonec2-ami ami-0ab16e79 --amazonec2-vpc-id <vpc-id> --engine-install-url "https://test.docker.com" --extension /Users/kcoleman/Desktop/student.json student001a

$ docker-machine -D create --driver amazonec2 --amazonec2-access-key <access-key> --amazonec2-secret-key <secret-key> --amazonec2-region "eu-west-1" --amazonec2-ami ami-0ab16e79 --amazonec2-vpc-id <vpc-id> --engine-install-url "https://test.docker.com" --extension /Users/kcoleman/Desktop/student.json student001b
```

#### AMI ID's in all regions.
Docker 1.9 Networking Requires a kernel version of 3.16 or greater.

| Region             | AMI-ID           
| -------------------|:------------:|
| US-East-1          | ami-f6e6979c |
| US-West-2          | ami-d79284b6 |
| US-West-1          | ami-fe2c429e |
| AP-Northeast-1     | ami-2c547542 |
| SA-East-1          | ami-a0e258cc |
| EU-West-1          | ami-0ab16e79 |
