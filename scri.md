貸主貸出主

Aliceのウォレット
"Alice"
tb1qzlevswmt0vlzzfx04anlsgcnnlhgcuyrj6d0j0
ボブのワレット
"Bob"
tb1qw6zhh3t347uswghamfcxncwsjrecnefj0ztg95


アリスのワレット
bitcoin-cli getaddressinfo tb1qzlevswmt0vlzzfx04anlsgcnnlhgcuyrj6d0j0
{
  "address": "tb1qzlevswmt0vlzzfx04anlsgcnnlhgcuyrj6d0j0",
  "scriptPubKey": "001417f2c83b6b7b3e2124cfaf67f823139fee8c7083",
  "ismine": true,
  "solvable": true,
  "desc": "wpkh([f22e986b/0'/0'/52']026fe64e9505df44463be4a0ab39a325357cbdf3a4b1bdba775b4330f1adc0c4d8)#vxd49yg4",
  "iswatchonly": false,
  "isscript": false,
  "iswitness": true,
  "witness_version": 0,
  "witness_program": "17f2c83b6b7b3e2124cfaf67f823139fee8c7083",
  "pubkey": "026fe64e9505df44463be4a0ab39a325357cbdf3a4b1bdba775b4330f1adc0c4d8",
  "ischange": false,
  "timestamp": 1618214923,
  "hdkeypath": "m/0'/0'/52'",
  "hdseedid": "92190eeee0e8a39c955e3355c72ed25a49e25b66",
  "hdmasterfingerprint": "f22e986b",
  "labels": [
    "Alice"
  ]
}

bitcoin-cli dumpprivkey tb1qzlevswmt0vlzzfx04anlsgcnnlhgcuyrj6d0j0
cNR2n4PEdxapNXgTDgczvAdenQuxJezdpBVoCEagwzxdfsuUoeKJ

ボブのワレット
bitcoin-cli getaddressinfo tb1qw6zhh3t347uswghamfcxncwsjrecnefj0ztg95
{
  "address": "tb1qw6zhh3t347uswghamfcxncwsjrecnefj0ztg95",
  "scriptPubKey": "001476857bc571afb90722fdda7069e1d090f389e532",
  "ismine": true,
  "solvable": true,
  "desc": "wpkh([f22e986b/0'/0'/53']02aa90db1c2437be930d948439b32ecc43850dad9aeaab19bbf4d10692958dce19)#29kqefc9",
  "iswatchonly": false,
  "isscript": false,
  "iswitness": true,
  "witness_version": 0,
  "witness_program": "76857bc571afb90722fdda7069e1d090f389e532",
  "pubkey": "02aa90db1c2437be930d948439b32ecc43850dad9aeaab19bbf4d10692958dce19",
  "ischange": false,
  "timestamp": 1618214923,
  "hdkeypath": "m/0'/0'/53'",
  "hdseedid": "92190eeee0e8a39c955e3355c72ed25a49e25b66",
  "hdmasterfingerprint": "f22e986b",
  "labels": [
    "Bob"
  ]
}
dumpprivkey tb1qw6zhh3t347uswghamfcxncwsjrecnefj0ztg95
cU789DU1JeYY26MoTFPqMYcbrHxeqGKhvktSgWbKS6XkqLP6XHg2

bitcoin-cli createmultisig 2 '["026fe64e9505df44463be4a0ab39a325357cbdf3a4b1bdba775b4330f1adc0c4d8","02aa90db1c2437be930d948439b32ecc43850dad9aeaab19bbf4d10692958dce19"]'



def send_multisig(amount, m, pubkeys, addr_change)
    # 所持金残高を確認
    balance = tapyrusRPC('getbalance', [])
    if balance < (amount+FEE) then
        puts "error (残高不足)"
    else
        # 送金金額＋手数料をぎりぎり上回るUTXOリストの作成
        utxos = consuming_utxos(amount+FEE)
        # 送金に使用するUTXOの総額
        fund = utxos.map{|utxo|utxo["amount"]}.sum
        # UTXOの総額 - 送金金額 - 手数料 = おつり
        change = fund-amount-FEE
        # redeem scriptの生成
        redeem_script = Tapyrus::Script.to_multisig_script(m,pubkeys)
        # トランザクションの構成（P2SH)
        tx = p2sh_tx(utxos, amount, redeem_script, addr_change)
        # トランザクションへの署名
        tx = sign_inputs(utxos, tx)
        # トランザクションのデプロイ
        txid = tapyrusRPC('sendrawtransaction',[tx.to_hex])
        # p2shトランザクションのアンロックに必要な情報の出力
        return tx, txid.chomp, redeem_script
    end
end

def unlock_p2wsh_tx(locked_txid, redeem_script_hex, addr, key1, key2)
    # redeem script の復元
    redeem_script = Bitcoin::Script.parse_from_payload(redeem_script_hex.htb)
    # アンロック対象トランザクションとUTXOを確定する
    locked_tx = Bitcoin::Tx.parse_from_payload(bitcoinRPC('getrawtransaction',[locked_txid]).htb)
    # ロックされているUTXO
    p2wsh_utxo = locked_tx.out
    # 0がP2WSHであることがわかっている
    utxo_vout = 0
    utxo_value = p2wsh_utxo[utxo_vout].value    # この金額の単位は satoshi
    # アンロックトランザクションの構成（送金先はaliceとする）
    p2wsh_tx = Bitcoin::Tx.new
    # inputの構成
    outpoint = Bitcoin::OutPoint.from_txid(locked_txid, utxo_vout)
    p2wsh_tx.in <<  Bitcoin::TxIn.new(out_point: outpoint)
    #output の構成 (P2WPKH) アドレスへ送金
    script_pubkey = Bitcoin::Script.parse_from_addr(addr)
    p2wsh_tx.out << Bitcoin::TxOut.new(value: utxo_value-(FEE*(10**8)).to_i, script_pubkey: script_pubkey)
    # アンロックトランザクションの署名対象のハッシュ値 sighash
    sighash = p2wsh_tx.sighash_for_input(0, redeem_script, sig_version: :witness_v0, amount: utxo_value, hash_type: Bitcoin::SIGHASH_TYPE[:all])
    # aliceとbobのsighashへの署名
    sig1 = key1.sign(sighash) + [Bitcoin::SIGHASH_TYPE[:all]].pack('C')
    sig2 = key2.sign(sighash) + [Bitcoin::SIGHASH_TYPE[:all]].pack('C')
    # witness scriptの追加
    p2wsh_tx.in[0].script_witness.stack << ""   # CHECKMULTISIGのバグ対応　NULLDUMMY　を入れる
    p2wsh_tx.in[0].script_witness.stack << sig1
    p2wsh_tx.in[0].script_witness.stack << sig2
    p2wsh_tx.in[0].script_witness.stack << redeem_script.to_payload
    # 署名したトランザクションをブロードキャストする
    p2wsh_txid = bitcoinRPC('sendrawtransaction', [p2wsh_tx.to_hex])
    return p2wsh_txid
end


issuetoken "token_type" "token_value" "txid/scriptpubkey" "index"

Issue new colored coins or tokens and store them in the wallet.

Arguments:

1. "token_type"       (numberic, required) Value can be 1 or 2 or 3.
1. REISSUABLE
2. NON-REISSUABLE
3. NFT
2. "token_value"      (numberic, required) Number of tokens to be issued
3. "scriptpubkey"     (string, optional) Script pubkey that is used to issue REISSUABLE token
3. "txid"             (string, optional) Transaction id from which the NON-REISSUABLE or NFT tokens are issued
4. "index"            (numeric, optional) Index in the above transaction id used for issuing token

Result:
{
  "color"               (string) The color or token.
  "txid":               (string) The transaction id in case of NON-REISSUABLE and NFC tokens.
   or
  "txids:"              (json array of string) The transaction ids of the two transactions created in case of REISSUABLE token
    [
      "txid1"           (string) transaction to create spendable UTXO
      "txid2"           (string) transaction to issue token spending the above UTXO
    ]
}

Examples:
> tapyrus-cli issuetoken "1" "100" 8282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508
> tapyrus-cli issuetoken "2" "1000" 485273f6703f038a234400edadb543eb44b4af5372e8b207990beebc386e7954 0
> tapyrus-cli issuetoken "3" "500" 485273f6703f038a234400edadb543eb44b4af5372e8b207990beebc386e7954 1


Burn colored coins or tokens in the wallet.

Arguments:

1. "color"              (string, required) The tapyrus color / token to burn.
2. "value"              (numeric, required) The amount to burn. eg 10

Result:
"txid"                  (string) The transaction id.

Examples:
> tapyrus-cli burntoken "c38282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23f" 10


近畿大学大学院産業理工学研究科　　　令和4年度

修士論文
ブロックチェーン上のトークンを利用した種子の貸付と利息の実現方法に関する研究

指導教員　山崎重一郎　教授

電子情報工学科
2133950003吉田直樹
