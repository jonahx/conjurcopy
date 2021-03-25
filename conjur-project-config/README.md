# IN PROGRESS, BREAKING CHANGES POSSIBLE

# Conjur Project Config

## Note: Intended For Internal Cyberark Use.

This project is intended for synchronizing common settings among different
Cyberark repositories, and is public so that public git repositories that 
need these settings won't need special permissions.  

However, contributing is limited to Cyberark developers.

## Goal

To ensure:

1. Consistent code standards 
2. Consistent developer experience

across all our repositories.

## What

This project houses configuration shared across other repositories.  Currently,
this includes:

1. Rubocop configuration
2. Code Climate configuration

It will soon include:

1. Enforce Rebase GH action

## Usage instructions

First embed this project into your "subscribing" project as a git submodule:

```bash
git add submodule -b main 'git@github.com:cyberark/conjur-project-config.git'
```

Then run:

```bash
./conjur-project-config/update
```

## Contributing

This project is intended for Conjur maintainers only. It is not open to
community contributions at this time.

### Public Discussion

Since changes to common settings affect all Conjur maintainers, we want
to make them by consensus.  Disputes, if they arise, can be settled by voting.

Please create an issue or PR that explains the changes you'd like to create.
The `@cyberark/developers` group will be tagged by default if you open a PR;
if you create an issue for discussion, you should tag this group manually.

Maintainers can emoji-react to share their feedback on the proposed change,
and a discussion can take place in the comments.

## License

Copyright (c) 2020 CyberArk Software Ltd. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

For the full license text see [`LICENSE`](LICENSE).
