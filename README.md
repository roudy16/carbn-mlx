## Setup

### Cloud Provider (DigitalOcean)
This project is setup to work with DigitalOcean. A Cloud Provider that supported
nested virtualization (KVM) was required, DigitalOcean popped up as a platform
that supported this and I was keen to check them out.

Set your personal access token in your environment:
```bash
export DO_PAT=<access-token>
```

The terraform scripts should work after that. Oh, install terraform.
