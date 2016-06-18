liquid-code
===========

About
-----
This code creates a non-standard QR code that I call liquid code. It is much
nicer than standard QR code.

I use it for business cards and doing nicer QR codes for my magazine articles
and Bitcoin donations.

Example code:
![alt text](https://github.com/jooray/liquid_code/raw/master/sample.png "Example liquid QR code")

Install
-------

Install as gem:

```bash
gem install liquid-code
```

Usage
-----

First we need to create a string to be embedded in QR code. Here are some
examples:

```ruby
mecard='MECARD:N:Surname,John;TEL:+421232222222;EMAIL:testaccount@gmail.com;;'
mecard='MECARD:N:Surname,John;TEL:+421232222222;TEL:+421910123123;EMAIL:testaccount@gmail.com;;'
mecard='MECARD:N:Surname,John;TEL:+421232222222;TEL:+421910123123;EMAIL:testaccount@gmail.com;NOTE:PGP AAEAAA70 FP A2A5AAA872938472938472938472834729847870;;'
mecard='bitcoin:16nz9k1hyPcdU1oSku23deGo7d5RRM1rPQ'
```

You can create LiquidCode representation from either a string:

```ruby
qr = LiquidCode.new(mecard)
```

or from RQRCode::QRCode, if you need more control about how the code
should look:

```ruby
qr = RQRCode::QRCode.new( mecard, :size => LiquidCode.minimum_qr_size_from_string(mecard), :level => :h )
```

Now let's create a PNG image:

```ruby
qrcode_data = qr.as_png('white', 'black', true, 10)

f = File.new("output.png",'w')
f.write(qrcode_data)
f.close
```


[There's also a script](examples/business_card_from_csv.rb) to create business card QR codes
from a CSV file (a PGP key fingerprint is included in NOTE when present). You
also need to change the company name in the ruby file.

Copying
-------

Author: Juraj Bednar, see COPYING for license (simplified BSD license)

Pull requests welcome, please contribute!

Bitcoin donations welcome at 16nz9k1hyPcdU1oSku23deGo7d5RRM1rPQ
Please donate if you use this.

