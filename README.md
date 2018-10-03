# rpm-deb-s3

This docker image contains two packages for pushing RPM and debian packages to S3 buckets:

* rpm-s3 python script from [crohr/rpm-s3](https://github.com/crohr/rpm-s3)
* [deb-s3](https://github.com/krobertson/deb-s3)

To push to AWS S3 you need `AWS_SECRET_KEY/AWS_ACCESS_KEY` pair. IAM roles is not supported.

You can also use GPG keys to sign your packages by passing the key details as environment variables.

To use the image:
```bash
docker run -it \
  -v $(pwd)/GPG_KEY.asc:/path/to/GPG_KEY.asc \
  -e GPG_KEY_PATH=/path/to/GPG_KEY.asc \
  -e GPG_KEY_NAME=KEY_NAME \
  -e GPG_KEY_PASS=... \
  -e AWS_ACCESS_KEY=... \
  -e AWS_SECRET_KEY=... \
  appwavelets/rpm-deb-s3:latest COMMAND
```

Then you can use any command to build, sign or push packages to S3:

```bash
# push RPM to s3
rpm-s3 -r us-east-1 -b BUCKET_NAME -p linux/centos/7/x86_64/stable/ /path/to/RPM_PACKAGE.rpm
rpm-s3 -r us-east-1 -b BUCKET_NAME -p linux/centos/6/x86_64/test/ /path/to/RPM_PACKAGE.rpm
# push debian to s3
deb-s3 upload --bucket BUCKET_NAME --prefix linux/ubuntu \
    --sign KEY_NAME --gpg-options='--batch --passphrase ... --pinentry-mode loopback' \
    -a amd64 -c xenial -m stable -p DEBIAN_PACKAGE.deb

deb-s3 upload --bucket BUCKET_NAME --prefix linux/debian \
    --sign KEY_NAME --gpg-options='--batch --passphrase ... --pinentry-mode loopback' \
    -a amd64 -c jessie -m test -p DEBIAN_PACKAGE.deb
# sign RPM package
# signing RPM will override the file, so don't mount RPM file
# to container as file directly, instead mount it in directory
rpm --addsign /path/to/RPM_PACKAGE.rpm
```
