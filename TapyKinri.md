二つのワレットを用意する
共通

require 'tapyrus'
require 'json'
require "open3"

include Tapyrus
include Tapyrus::Opcodes
FEE = 0.00002       # 手数料
Tapyrus.chain_params = :prod

# tapyrus-cli コマンドのフルパス

Tapyrus_cli ='~/tapyrus-core-X.X.X/bin/tapyrus-cli' #Xはバージョン

# RPC

def tapyrusRPC(method,params)
    r=Open3.capture3("#{Tapyrus_cli} #{method} #{params.join(' ')}")
    if r[1] == "" then
        begin
            return JSON.parse(r[0])
        rescue JSON::ParserError
            return r[0]
        end
    else
        return r[1]
    end
end

アカウントの作成
mnemonic = Tapyrus::Mnemonic.new('english')
entropy = SecureRandom.hex(32)
word_list = mnemonic.to_mnemonic(entropy)


使用するカラードコインのアドレスとトランザクションID
tapyrus-cli issuetoken "1" "100" 76a914927508e4db9b734bbabb709d99c31944927e4a8b88ac
{
  "color": "c1fb6f0f566693f453c4f1377ce940cdeb086990b5c91b2aae069e598184002cb4",
  "txids": [
    "20ccdd03a5112324c7bad03d40c642f7ce6967571577970a934c09973edb3fce",
    "a2f14884a69c835a5f973190abdea8f62690fb5b2be55d4762792aa68091d04b"
  ]
}
使用元のトランザクション
{
    "txid": "7fd9bb668eedc2b730df5f68773f6559a7140512ef1f40f0e50d00af6d2daff3",
    "vout": 1,
    "address": "1EMPriyTkNL46Gqs1JP8GqhQoBLyi6cB9Y",
    "token": "TPC",
    "amount": 0.97999550,
    "label": "",
    "scriptPubKey": "76a914927508e4db9b734bbabb709d99c31944927e4a8b88ac",
    "confirmations": 73769,
    "spendable": true,
    "solvable": true,
    "safe": true
  }

{"txid"=>"a81ba40b21516551c38423c3f959e78bc233ace0bf97387ada0e8a19d46ac08a", "vout"=>0, "address"=>"1LW292QmxhefJ2eQUvtBijno7XwGpVnxJB", "token"=>"TPC", "amount"=>1.0, "label"=>"", "scriptPubKey"=>"76a914d5e7672d020cfa9404b77ec4da7f5fdc0709fb1488ac", "confirmations"=>81880, "spendable"=>true, "solvable"=>true, "safe"=>true}

tapyrusRPC('getrawtransaction',["9ca378cbe9587ca75d48508c96165c229f11d4a
=> "0100000001ce3fdb3e97094c930a977715576769cef742c6403dd0bac7242311a503ddcc20010000006a47304402207b2b327e37c61befdf9bb12dc45c34e95fdc8a229e54f82b90faee73a3de67350220190ab56224a8e5d6adac7d97e84cd1b99517678bec6b77338edc1c51105e89e20121022278120c1116ab83e06cd6428af9794c341356ce3b364be9f72c767e78e6f451feffffff02204e0000000000001976a914d5e7672d020cfa9404b77ec4da7f5fdc0709fb1488ac00f61c00000000001976a9143bd7adaa7242e60f8c8072efa66f67cc15083b4888ac7c240400\n"

tapyrusRPC('decoderawtransaction',["0100000001ce3fdb3e97094c930a97771557
=> {"txid"=>"9ca378cbe9587ca75d48508c96165c229f11d4a0368d8db6ab2f74d5cf2c8c31", "hash"=>"382acaeebeab7ee739f92e4119a26970f6000ecf97498851ee516135384bf707", "features"=>1, "size"=>225, "locktime"=>271484, "vin"=>[{"txid"=>"20ccdd03a5112324c7bad03d40c642f7ce6967571577970a934c09973edb3fce", "vout"=>1, "scriptSig"=>{"asm"=>"304402207b2b327e37c61befdf9bb12dc45c34e95fdc8a229e54f82b90faee73a3de67350220190ab56224a8e5d6adac7d97e84cd1b99517678bec6b77338edc1c51105e89e2[ALL] 022278120c1116ab83e06cd6428af9794c341356ce3b364be9f72c767e78e6f451", "hex"=>"47304402207b2b327e37c61befdf9bb12dc45c34e95fdc8a229e54f82b90faee73a3de67350220190ab56224a8e5d6adac7d97e84cd1b99517678bec6b77338edc1c51105e89e20121022278120c1116ab83e06cd6428af9794c341356ce3b364be9f72c767e78e6f451"}, "sequence"=>4294967294}], "vout"=>[{"token"=>"TPC", "value"=>0.0002, "n"=>0, "scriptPubKey"=>{"asm"=>"OP_DUP OP_HASH160 d5e7672d020cfa9404b77ec4da7f5fdc0709fb14 OP_EQUALVERIFY OP_CHECKSIG", "hex"=>"76a914d5e7672d020cfa9404b77ec4da7f5fdc0709fb1488ac", "reqSigs"=>1, "type"=>"pubkeyhash", "addresses"=>["1LW292QmxhefJ2eQUvtBijno7XwGpVnxJB"]}}, {"token"=>"TPC", "value"=>0.01897984, "n"=>1, "scriptPubKey"=>{"asm"=>"OP_DUP OP_HASH160 3bd7adaa7242e60f8c8072efa66f67cc15083b48 OP_EQUALVERIFY OP_CHECKSIG", "hex"=>"76a9143bd7adaa7242e60f8c8072efa66f67cc15083b4888ac", "reqSigs"=>1, "type"=>"pubkeyhash", "addresses"=>["16TREv42z8sAj61CEnbHZmXpND2WrkGP5w"]}}]}
