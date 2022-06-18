## HTLCスクリプト

#### 下準備

#### アドレスの作成
```
➜  ~ bitcoin-cli getnewaddress HAlice
tb1qd6w09jz2ul973fe8rwdvt0dhja8y44twwkrz2c
➜  ~ bitcoin-cli getnewaddress HBob
tb1qwxygraf9pfpv2h3jzeqvq079mxgmgw4yzc8u0w

```

### HAliceとHBobの秘密鍵　
```
➜  ~ bitcoin-cli dumpprivkey tb1qd6w09jz2ul973fe8rwdvt0dhja8y44twwkrz2c
cW7eXrCgUYLYL4nEkzKFdaZpvE1zWbLDESdiG1Et2MYh4c9zth2W
➜  ~ bitcoin-cli dumpprivkey tb1qwxygraf9pfpv2h3jzeqvq079mxgmgw4yzc8u0w
cSPcGeZumXbMkvkr4ZrwwPmtsGhy5vk2U5mbAeeL3VEZPejQWW5r
```
#### HAliceに送金
```
➜  ~ bitcoin-cli send '{"tb1qd6w09jz2ul973fe8rwdvt0dhja8y44twwkrz2c":0.01}'
{
  "txid": "07881a16495547bdaf8cf66055556c612a71e6f479cd040e7000155cd161eaa0",
  "complete": true
}

```

#### 基本の呼び出し

```
irb
>> require 'em/pure_ruby' if not defined?(EventMachine)
=> true
>> require 'bitcoin'
=> true

>> require 'net/http'
=> true
>> require 'json'
=> false
>> include Bitcoin
=> Object
>> include Bitcoin::Opcodes
=> Object
#　チェーンの選択

>> Bitcoin.chain_params = :signet
=> :signet
HOST="localhost"
PORT=38332          # mainnetの場合は 8332
RPCUSER="Naoyo"      # bitcoin core RPCユーザ名
RPCPASSWORD="yamaken21"  # bitcoin core パスワード


# bitcoin core RPC を利用するメソッド

def bitcoinRPC(method, params)
    http = Net::HTTP.new(HOST, PORT)
    request = Net::HTTP::Post.new('/')
    request.basic_auth(RPCUSER, RPCPASSWORD)
    request.content_type = 'application/json'
    request.body = { method: method, params: params, id: 'jsonrpc' }.to_json
    JSON.parse(http.request(request).body)["result"]
end

```

## 先ほど作成したHAliceとHBobのアドレスと秘密鍵(WIF形式)
```
>> HTAlice = "tb1qd6w09jz2ul973fe8rwdvt0dhja8y44twwkrz2c"
=> "tb1qd6w09jz2ul973fe8rwdvt0dhja8y44twwkrz2c"
>> HTBob = "tb1qwxygraf9pfpv2h3jzeqvq079mxgmgw4yzc8u0w"
=> "tb1qwxygraf9pfpv2h3jzeqvq079mxgmgw4yzc8u0w"
>> privHAlice = "cW7eXrCgUYLYL4nEkzKFdaZpvE1zWbLDESdiG1Et2MYh4c9zth2W"
=> "cW7eXrCgUYLYL4nEkzKFdaZpvE1zWbLDESdiG1Et2MYh4c9zth2W"
>> privHBob = "cSPcGeZumXbMkvkr4ZrwwPmtsGhy5vk2U5mbAeeL3VEZPejQWW5r"
=> "cSPcGeZumXbMkvkr4ZrwwPmtsGhy5vk2U5mbAeeL3VEZPejQWW5r"

>> keyHTAlice = Bitcoin::Key.from_wif(privHAlice)
=> #<Bitcoin::Key:0x00007fba4c45ead0 @key_type=1, @secp256k1_module=Bitcoin::Secp256k...
>> keyHTBob = Bitcoin::Key.from_wif(privHBob)
=> #<Bitcoin::Key:0x00007fba4c41ecf0 @key_type=1, @secp256k1_module=Bitcoin::Secp256k...


>> keyHTAlice
=> #<Bitcoin::Key:0x00007fba4c45ead0 @key_type=1, @secp256k1_module=Bitcoin::Secp256k1::Ruby, @priv_key="fe9e7dfc1ad42e22cb1cdb3a132fab70fee9fd741a71a83b162265bac6649912", @pubkey="034690c260875f700cff6a6752013c32c0ca2191343afe614d8b8ef5e365354c72">
>> keyHTBob
=> #<Bitcoin::Key:0x00007fba4c41ecf0 @key_type=1, @secp256k1_module=Bitcoin::Secp256k1::Ruby, @priv_key="8f7affcc63f637c23647e5fe414c1d5e27e9c1e187aaefa1bf32226516b17515", @pubkey="02d97d96d84bfc7fbf66c0108cabdfc326a59ca38d3f6b273156f03e9df3c4930a">
```
秘密鍵の形式はここに詳しく書いてある
<https://techmedia-think.hatenablog.com/entry/2016/01/08/114213>

## HTAliceのUTXO
```
>> bitcoinRPC('listunspent',[]).select{|x| x["address"]==HTAlice}
=> [{"txid"=>"07881a16495547bdaf8cf66055556c612a71e6f479cd040e7000155cd161eaa0", "vout"=>0, "address"=>"tb1qd6w09jz2ul973fe8rwdvt0dhja8y44twwkrz2c", "label"=>"HAlice", "scriptPubKey"=>"00146e9cf2c84ae7cbe8a7271b9ac5bdb7974e4ad56e", "amount"=>0.01, "confirmations"=>4, "spendable"=>true, "solvable"=>true, "desc"=>"wpkh([f22e986b/0'/0'/46']034690c260875f700cff6a6752013c32c0ca2191343afe614d8b8ef5e365354c72)#f0wd0yj9", "safe"=>true}]

```

## UTXOSに代入
```
>> UTXOS = bitcoinRPC('listunspent',[]).select{|x| x["address"]==HTAlice}
=> [{"txid"=>"07881a16495547bdaf8cf66055556c612a71e6f479cd040e7000155cd161eaa0", "vou...

>> UTXOAmount = UTXOS[0]["amount"]
=> 0.01
>> UTXOVout = UTXOS[0]["vout"]
=> 0
>> UTXOTxid = UTXOS[0]["txid"]
=> "07881a16495547bdaf8cf66055556c612a71e6f479cd040e7000155cd161eaa0"

```

秘密情報の作成
```
#secretをSHA256でハッシュ化する
secret='Tapyrus'
>> Secret_Hash = Bitcoin.sha256(secret)
=> "U\xCD\x97\x17[\x90\xBB\xA2\x95\x7Fb\xBC\x9BP\x1D\x97\xD8\xEB\xDA\xB1a`;\x02\xD1\x...


>>  Secret_Hash
=> "U\xCD\x97\x17[\x90\xBB\xA2\x95\x7Fb\xBC\x9BP\x1D\x97\xD8\xEB\xDA\xB1a`;\x02\xD1\x9F\xFF\x88\x89\xA2#\x16"

#スクリプトのテスト
>> ts = Bitcoin::Script.new << secret.bth << OP_SHA256 << Secret_Hash << OP_EQUAL
=> #<Bitcoin::Script:0x00007fba4c47d110 @chunks=["\aTapyrus", "\xA8", " U\xCD\x97\x17...
>> ts
=> #<Bitcoin::Script:0x00007fba4c47d110 @chunks=["\aTapyrus", "\xA8", " U\xCD\x97\x17[\x90\xBB\xA2\x95\x7Fb\xBC\x9BP\x1D\x97\xD8\xEB\xDA\xB1a`;\x02\xD1\x9F\xFF\x88\x89\xA2#\x16", "\x87"]>

>> ts.run
=> true

```