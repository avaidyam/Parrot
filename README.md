# Introduction

Parrot is an extensible (for now only) OS X instant messaging architecture. It currently features a reverse-engineered API for Google Hangouts, with scaffolding around it for multifaceted use. In the future, Facebook Messenger, custom Jabber, WhatsApp, and more protocols may be supported, depending on API availability (or reverse engineering).

----------
# Images
![Parrot](https://raw.githubusercontent.com/avaidyam/Parrot/master/Documentation/images/Parrot.png "Parrot")
![parrot-cli](https://raw.githubusercontent.com/avaidyam/Parrot/master/Documentation/images/parrot-cli.png "parrot-cli")

----------
# Acknowledgements
- Tom Dryer, for reverse-engineering the Hangouts protocol in `hangups`
- Peter Sobot, for the initial translation and development of `Hangover`, a Swift port of `hangups`, which was used as the initial code base for Parrot's Hangouts component.