from bigchaindb_driver import BigchainDB
from bigchaindb_driver.crypto import generate_keypair


bdb_root_url = 'https://127.0.0.1:9984'
bdb = BigchainDB(bdb_root_url)
pulseReadings = {
  'data': {
	'pulseReading': {
		'hashVal':'QmYKk58w8pFbstWfYMT2bY2PkmiFEBRz7MZHyBXHZegc9H'
		'device':'fitbit'
	}
  }
}

metadata = {
	'identiy': 'required'
	'access time': '20 min'
	'
}
#can also use the member's own public key
myKey = generate_keypair()
prepared_creation_tx = bdb.transactions.prepare(
        operation='CREATE',
        signers=myKey.public_key,
        asset=pulseReading,
        metadata=metadata,
    )

fulfilled_creation_tx = bdb.transactions.fulfill(
        prepared_creation_tx, private_keys=myKey.private_key)

#send to bigchainDb node
sent_creation_tx = bdb.transactions.send_commit(fulfilled_creation_tx)
txid = fulfilled_creation_tx['id']
block_height = bdb.blocks.get(txid=signed_tx['txid'])
