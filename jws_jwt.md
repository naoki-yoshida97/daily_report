## JWS/JWTの違いを理解する
- JWS(JSON Web Signature)
- JWT(JSON Web Token)

JWS<br>
仕組みとしては
署名アルゴリズム(どういうアルゴリズムで署名しているのか)とデータペイロード(署名対象のデータ)をBASE64URLにエンコードした後にHASH値をとり秘密鍵と合わせてHMACを取得しそれを署名するもの
- JOSE Header
- JWS Payload
- JWS Signature

JWS
JOSE Headerの署名の対象データ(JWS Payload)は署名方式は何かを定義する。
JSON形式になっている

HeaderがJSONであればPayload部分もJSONNで行うのが自然
そのための規格がJWT(Json Web Token)



内容を知ってるコメディドラマ