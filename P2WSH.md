### P2WSH(マルチシグ)

### まずはコンソール上で確認

```
使用するアドレス
➜  ~ bitcoin-cli getnewaddress
tb1qleka6fpjhj80sjp6z5m5psyexazvsm4k0ereun
"pubkey": "0286d64024cceaddec4edb706d3558e3e1a9a424dbf3807e1ed465b2e6b835629e"
➜  ~ bitcoin-cli getnewaddress
tb1qap3cuvmv6pmpjqgr2z7q5d2ejhn7h4n5xt0jm7
"pubkey": "03c9eea0dc71542c6226cf7297fd070447e1f0c6bd84b73afb526a55f6c17f4428"
➜  ~ bitcoin-cli getnewaddress
tb1qqxyfndjxpjr70xzvjzhj09sjjwg5lyqkvwnlrk
"pubkey": "033979d9ede19c1b6a7b40a23d648ccad1a5cd552b788c4ca877f0109b841c53b0"
```

### できたアドレスP2SH類
```
bitcoin-cli createmultisig 2 '["0286d64024cceaddec4edb706d3558e3e1a9a424dbf3807e1ed465b2e6b835629e","03c9eea0dc71542c6226cf7297fd070447e1f0c6bd84b73afb526a55f6c17f4428","033979d9ede19c1b6a7b40a23d648ccad1a5cd552b788c4ca877f0109b841c53b0"]'
{
  "address": "2N8qz5UH78xUiMahAFEEJHYZD4nXqbdDdA8",
  "redeemScript": "52210286d64024cceaddec4edb706d3558e3e1a9a424dbf3807e1ed465b2e6b835629e2103c9eea0dc71542c6226cf7297fd070447e1f0c6bd84b73afb526a55f6c17f442821033979d9ede19c1b6a7b40a23d648ccad1a5cd552b788c4ca877f0109b841c53b053ae",
  "descriptor": "sh(multi(2,0286d64024cceaddec4edb706d3558e3e1a9a424dbf3807e1ed465b2e6b835629e,03c9eea0dc71542c6226cf7297fd070447e1f0c6bd84b73afb526a55f6c17f4428,033979d9ede19c1b6a7b40a23d648ccad1a5cd552b788c4ca877f0109b841c53b0))#6393tv9s"
}

```

### できたP2WSHアドレス類
```
bitcoin-cli createmultisig 2 '["0286d64024cceaddec4edb706d3558e3e1a9a424dbf3807e1ed465b2e6b835629e","03c9eea0dc71542c6226cf7297fd070447e1f0c6bd84b73afb526a55f6c17f4428","033979d9ede19c1b6a7b40a23d648ccad1a5cd552b788c4ca877f0109b841c53b0"]' bech32
{
  "address": "tb1qdkgt9vaf973qz805p8gvr02e5e5ukmd4u008z8j40j2gtsg9z5kqqn4u53",
  "redeemScript": "52210286d64024cceaddec4edb706d3558e3e1a9a424dbf3807e1ed465b2e6b835629e2103c9eea0dc71542c6226cf7297fd070447e1f0c6bd84b73afb526a55f6c17f442821033979d9ede19c1b6a7b40a23d648ccad1a5cd552b788c4ca877f0109b841c53b053ae",
  "descriptor": "wsh(multi(2,0286d64024cceaddec4edb706d3558e3e1a9a424dbf3807e1ed465b2e6b835629e,03c9eea0dc71542c6226cf7297fd070447e1f0c6bd84b73afb526a55f6c17f4428,033979d9ede19c1b6a7b40a23d648ccad1a5cd552b788c4ca877f0109b841c53b0))#09zuawsw"
}

```

### 自分のワレットにimport
```
bitcoin-cli importmulti '[{"desc":"wsh(multi(2,0286d64024cceaddec4edb706d3558e3e1a9a424dbf3807e1ed465b2e6b835629e,03c9eea0dc71542c6226cf7297fd070447e1f0c6bd84b73afb526a55f6c17f4428,033979d9ede19c1b6a7b40a23d648ccad1a5cd552b788c4ca877f0109b841c53b0))#09zuawsw","timestamp":"now","watchonly": true}]'
[
  {
    "success": true
  }
]
```
createmultisigでできた情報の中から"descriptor"を使用する。
timestampとwatchonlyは忘れない




メモ
保管庫が多重署名
