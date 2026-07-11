# Secure-data recovery

A usable recovery requires the control repository, the matching PKCS7 keypair,
and evidence that the pair can decrypt data. The control-plane backup already
includes `/etc/sasd-puppet` when present.

1. Verify and extract only into an isolated directory with
   `recovery-readiness.py` and `rehearse-recovery.sh`.
2. Locate the recovered public and private PKCS7 files.
3. Compare their RSA moduli and run an isolated encrypt/decrypt roundtrip.
4. Restore neither keys nor services to live paths during the rehearsal.
5. On a replacement compiler, install the pinned gem, restore keys with their
   documented ownership/modes, deploy `test`, compile the encrypted consumer,
   and only then promote production.

If a private key is lost, existing encrypted values cannot be recovered. Rotate
the affected external credential and encrypt the replacement with a new keypair.
