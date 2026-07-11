# ADR 0046: Sensitive redaction does not encrypt catalogs

`Sensitive` and Sensitive EPP prevent routine log/report disclosure but do not
encrypt the compiled or cached catalog. High-value keys and human credentials
therefore remain prohibited. Node-side deferred secret retrieval may be
evaluated later if the risk profile requires it.
