### bitcoinrbを利用したP2WSHスクリプト


### 基本の呼び出し

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
