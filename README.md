# aistack
*An automatically-bootstrapped AI research environment with (huge, maybe too much) batteries included*

## Installing `aistack`
Please, do yourself a favour: do not try to install `aistack` by using this repository. The way it is supposed to be is way easier.

Provided that you have already installed all the required (and, eventually, optional) dependencies, just do:
```
wget https://ballarin.cc/aistack/asrinit.sh
chmod +x ./asrinit.sh
./asrinit.sh
```

While the relevant documentation is being written (and this README updated), you can find a list of the required and optional dependencies at the beginning of [this file](https://github.com/emaballarin/emaballarin.github.io/blob/master/aistack/asrinit.sh).

---

## What is this repository all about?

The place where `aistack` is usually developed, tested, maintained - and which sort of serves as a *ground truth implementation* is [here](https://github.com/emaballarin/emaballarin.github.io/tree/master/aistack). This way it is accessible through GitHub pages and served at [ballarin.cc](https://ballarin.cc/aistack/) for easier download and deployment (see above for instructions).

In the usual-case scenario, this repository will be kept (manually, via a script) in sync with [this folder](https://github.com/emaballarin/emaballarin.github.io/blob/master/aistack) from time to time. This means that this repository *may, sometimes* lag behind the latest version available at [ballarin.cc](https://ballarin.cc/aistack/), though this is not the expected behaviour.

Being available, and more accessible, here, this means it is more easily exposed to public scrutiny (and eventual bug-fixing). If you find a bug, or want to suggest improvements, *or whatever*, feel free to open here a pull request or issue.
<br> In case the point is still valid for the latest version, and the pull request is merged (it will be!) and/or the issue is resolved, *manual sync* will take place the other way round.
