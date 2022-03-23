---
title: "Source"
---

# Directory Server Source Code
------------------------------

{% include toc.md %}

These are the sources used by the directory server which are provided by the project (as opposed to third party sources like the Mozilla components, berkeley db, etc.).

[All the source tarballs]({{ site.binaries_url }}/binaries/)

All of the source is now in git. The git module given below is a sub-directory of the base git URL **git@github.com:389ds/389-ds-base.git** - so for the base directory server, the full git URL is **https://github.com/389ds/389-ds-base.git**

The idm-console-framework is not under 389/ it is at **git://git@pagure.io/idm-console-framework.git**

The source code was produced by first doing a git clone to get the repository, then a git archive to produce the source tarball

    git clone git@github.com:389ds/389-ds-base.git

    git archive --prefix=PKGNAME/ TAG | bzip2 > PKGNAME.tar.bz2

### 389 Directory Server 2.1.0

|Source tarball|git module|git tag|More Info|SHA512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-2.1.1.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.1.1.tar.gz)|389-ds-base.git|389-ds-base-2.1.1|[Building](building.html)|38feb135847ef409e03642433a84aea84b65f7c0d55cae35e71ff3c541e2c33bb5c1b207096438c7578db7ec98ce8b3fa3a0282d3ca0637ad9e593bc324fb78c|
|[389-ds-base-2.1.0.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.1.0.tar.gz)|389-ds-base.git|389-ds-base-2.1.0|[Building](building.html)|496195b848566a0ccee272f06a041e2f764a5c8f3d84651a0fc3c7ca9128102ac6e8a8c9ae0945ce1742f39006daa724e394d0481d7c494a9701bf6c8709be51|

### 389 Directory Server 2.0.0

|Source tarball|git module|git tag|More Info|SHA512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-2.0.15.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.15.tar.gz)|389-ds-base.git|389-ds-base-2.0.15|[Building](building.html)|5eaa2c7720ac0aa595f03226267af51923bc05638afc8c525007341a598a843d0db34af606c8d3b161edfd4c3656d5ad448cd426fa1ccacd54ba64fba43010ef|
|[389-ds-base-2.0.14.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.14.tar.gz)|389-ds-base.git|389-ds-base-2.0.14|[Building](building.html)|803520ea4901d71021ff2771ea175fb5c30d02705eff51d24d68f1a537194c4766e0618d6a89590b46bbcce03d7b17245260e9930351f41e78a61d29de1363d4|
|[389-ds-base-2.0.13.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.13.tar.gz)|389-ds-base.git|389-ds-base-2.0.13|[Building](building.html)|ab9429b391b32d4a09ea5fb0ce15fcf31f7c13e781588ce5587a0ed169959938ce59bff857dbf58bb9413208f6c35792c127cad27c7aca6aa53ef66ef4c36196|
|[389-ds-base-2.0.12.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.12.tar.gz)|389-ds-base.git|389-ds-base-2.0.12|[Building](building.html)|add9ad43f9ab50e8ab10bba2a2daef3b201adae0367a28b9814f17c6130a8cb6287391352951a6528c9a16d8139133c8b8ac08bc9436b587c8790ac5b30d0cff|
|[389-ds-base-2.0.11.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.11.tar.gz)|389-ds-base.git|389-ds-base-2.0.11|[Building](building.html)|23869b5ec8d0fd2774682b5c2dfd1d60dc99a50f5817e25dca50f1eb62d2553f11f7249c7751d1e010bf0c1a0380ec08f56fc5b3f7d66f439a6e350913912318|
|[389-ds-base-2.0.10.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.10.tar.gz)|389-ds-base.git|389-ds-base-2.0.10|[Building](building.html)|2ae362386c72c2b6408d7f0ba8e04f3f2b4a750e4c60aa8915fd513994da62f4ac6bf10dcf69b75504611b082527b906cfa0c507d0aaf48b5f729b7acaa80b4f|
|[389-ds-base-2.0.9.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.9.tar.gz)|389-ds-base.git|389-ds-base-2.0.9|[Building](building.html)|ae5ef82d46dcd3ced3eb2c75ca970cdfd13a174b2f0a0611078f6dfb7cc9809fc650e8243a162939ff44bf81a04feea1707e2b1cfa63612577987c0281d3042f|
|[389-ds-base-2.0.8.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.8.tar.gz)|389-ds-base.git|389-ds-base-2.0.8|[Building](building.html)|04f3a37da3d7f77501b0a3468b458c0da38266e56064e78ba3196a3be209bc870e6d4bde43cc39ece933bf1314453204223d34bc337cd3ede21d646fb54f1a31|
|[389-ds-base-2.0.7.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.7.tar.gz)|389-ds-base.git|389-ds-base-2.0.7|[Building](building.html)|05a307d2bfbf47e60cab236f4b9f931820e33e208579422e85f2823eb19dbd45dbab5758366c1be48cbdcdf5fbf128ab3d6700ec2be1fe61dd63b9b1f855f30f|
|[389-ds-base-2.0.6.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.6.tar.gz)|389-ds-base.git|389-ds-base-2.0.6|[Building](building.html)|3a988207d1883e06c447d61906aa6a39eba229f77d7c6d6e0767fdc81b3c53256d829817d18b06e58460a0ea5ec1bf4e915a2b6aded3bdea23831ff767e31cf8|
|[389-ds-base-2.0.5.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.5.tar.gz)|389-ds-base.git|389-ds-base-2.0.5|[Building](building.html)|727da122b16285a8c2bd096a599e106c712e09c3aad32c23311f9e4cd3481792f5fca565fa8dcafcfa5710bda2ec6024edac44ff06cbd2af318ecf3f4563b908|
|[389-ds-base-2.0.4.tar.bz2](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.4.tar.gz)|389-ds-base.git|389-ds-base-2.0.4|[Building](building.html)|accf7bbcd36c2ff52cca6f4ab3a58b5842938766981ff321b03d2e6adaab9c328253bee5b57cd9f43d0f047aca50f9aea880508ae4ca5d836c65ba7dc67b142a|
|[389-ds-base-2.0.3.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-2.0.3.tar.bz2)|389-ds-base.git|389-ds-base-2.0.3|[Building](building.html)|48f0dcd7e4853646ea9bb38ec742f2b421b7bd6477d33070a8c97a764021ab7fa6fc005cb75ea87860b7b70998dc4df87790cf1c2bda3e6c0a9f08d39b00f6d2|
|[389-ds-base-2.0.2.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-2.0.2.tar.bz2)|389-ds-base.git|389-ds-base-2.0.2|[Building](building.html)|42805311e45b2f3305f86da50d5a0128b19cd15aeb4787ccb67b5ceea9f7a7efe42076dff1d47d4d61012453405403c730c245d53431043eb05c125455938c37|
|[389-ds-base-2.0.1.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-2.0.1.tar.bz2)|389-ds-base.git|389-ds-base-2.0.1|[Building](building.html)|34395b9fc73965518b4e0fc1ad5e2053bb0bb2fe38367437dd17a5a735d3d11106d510d43939083cbebcdff9c7790b367b44a3a563fb37899105ad24865eaa2b|


### 389 Directory Server 1.4.5 (this branch became 2.0.0 ...)

|Source tarball|git module|git tag|More Info|SHA512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.4.5.0.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.5.0.tar.bz2)|389-ds-base.git|389-ds-base-1.4.5.0|[Building](building.html)|a60299348f5f7c56293e8cfb57544fc28ac2b240ec1546eec96a8884340e971ecd1872e0a316ac532f5a431875f1314eea6cb85fd551f49857e891dd9b0ef385|

### 389 Directory Server 1.4.4

|Source tarball|git module|git tag|More Info|SHA512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.4.4.16.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.16.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.16|[Building](building.html)|7509132b9088d9f1e915a848e19de2dd6779a27ba09f9337c3642548fa62160151e4c20da76854c8a1b8b929147acc0fe8a9cbcd8735dabd22700b99129475c0|
|[389-ds-base-1.4.4.15.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.15.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.15|[Building](building.html)|f8a6b1dc099d1636ffaa9d7461b685175cc84e03da4c4a70652610fb36d553cbf5d9baea883bb0e950b9ca306b6765f56002062b2f2ea8f819d479e373f30ccd|
|[389-ds-base-1.4.4.14.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.14.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.14|[Building](building.html)|550925dad97dc093c6f81761813b795b34a953b3ed4eed563cc06d68c692417c1de8c58c4739121d12dc16bb9e2f23d57a6ab9f9f78cb43cba1829c6ad157974|
|[389-ds-base-1.4.4.13.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.13.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.13|[Building](building.html)|bd0c78d0845a1e65346ebe823d322b5686a42dfdfef97c40d0504aa85781218dd0748024102e2ddc9fe5677562655dace9f366625f3d4ef3bed2f938edc098f8|
|[389-ds-base-1.4.4.12.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.12.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.12|[Building](building.html)|9e2b4a1f28e3335fd92e3be607ec804330607cfd4fe819d5c04610f67f7598a6d4ee84d2a271aa0c432a429e80079258fc32c5044fac32612b0b2790904233ad|
|[389-ds-base-1.4.4.11.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.11.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.11|[Building](building.html)|37bda0cffd880296d5d74a361c35dddddb161fad2bf81e063b6aff98006bcab1f5c159329aba376bebf2971bff36c0668af01b20e3049d713175bd00f96c8cb4|
|[389-ds-base-1.4.4.10.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.10.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.10|[Building](building.html)|f8b6a51ca31d6039cc9f75b9cb7ecba7948e1619faf5de8e7a2bc411c68af5326ae250c60148d52e65f32ac8559cebe6f8d85c7741bf6bfb72fdd061ce2a36be|
|[389-ds-base-1.4.4.9.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.9.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.9|[Building](building.html)|556edae2764baad7fa99eba8005cbb203a6bb6c9f9bd91194b29c2e187ebe788230438c528757424d86be00636d08d75c894440c67506765a4d1b65fa7b05206|
|[389-ds-base-1.4.4.8.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.8.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.8|[Building](building.html)|44c5949cd17c722dca3f8c24bcdedf55090cabe0d17fb447d3e600ff83e1919544670eb27ce013f6b2b6a563cc9b4aee46ff78e95ca82a91b9b0de9aefbddac9|
|[389-ds-base-1.4.4.7.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.7.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.7|[Building](building.html)|c0980c2b69ac64f57675d763b5874db139a374cb8196ba969d907a9ac2fb42bffd47c8b971bf6f1514df144185a5d2c9487656c2359cbcefb66bba85bdd99092|
|[389-ds-base-1.4.4.6.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.6.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.6|[Building](building.html)|4ce55096ce82b4de40341348ee6e8e785b27759980b5400567033ebeafd4b87317932d005ea213985db9a642aab11799c01e96a0a6df6747a92cbbda0c283c81|
|[389-ds-base-1.4.4.5.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.5.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.5|[Building](building.html)|a96bb31b9ac635d34191f65998bcec265d4bc1898e85c80f524137472806861cce1cb3845fa1b037285315bbce59e054fd14058c316b27e2c09039827b58f60e|
|[389-ds-base-1.4.4.4.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.4.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.4|[Building](building.html)|e819a736ba30a1b2c35a180dac9815b7f90d1de32050c87f4fd996596ab466b603deca3ab0701eaf4753e820a23dc53f67f68a35397bbbbe41cf655b4a679bef|
|[389-ds-base-1.4.4.3.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.3.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.3|[Building](building.html)|1e8e2ae09098595a6d23a7a5f3266cd307089531ac34cf9dce0d50b6c590593da8c03ec3260e88100da644161c7ca026e7d7751d15822823b4ed3ff4f80c4b14|
|[389-ds-base-1.4.4.2.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.2.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.2|[Building](building.html)|cc497f6e2382e860e185489f271a5071e97ee9c7096b6c94ac04b3fc7f4a93f9b60026d16167930771879647076958ecf1562c1d5724a9220262ff76916dc048|
|[389-ds-base-1.4.4.1.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.1.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.1|[Building](building.html)|ca56079c93be95ffacccd8f4f18f5aa3f1039cc61b661d14737f485937eddb6120313c3f50e38f6daba6caf76102d6e4c537fa0bffb941896dfff93f44fd597b|
|[389-ds-base-1.4.4.0.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.0.tar.bz2)|389-ds-base.git|389-ds-base-1.4.4.0|[Building](building.html)|6c0e8ac5173c98da8c51cb6a7780376abceeb42fd4354d79bf7c1ed6627bb74433a983acca4ffa53ed6888dacaee6eaf4a92d907265a4e81c6efef7fe1f6d9be|

### 389 Directory Server 1.4.3

|Source tarball|git module|git tag|More Info|SHA512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.4.3.23.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.23.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.23|[Building](building.html)|6084ef48e7665a3cbb2953be345bc96bdfe024297610719f2c5a788e9e99f5527702799dd17d5ee1f56fc588d862a51326633e656c0a76678f816da98c318cd0|
|[389-ds-base-1.4.3.22.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.22.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.22|[Building](building.html)|5b4a5718dfd5c5334ac865bbd3e7ffaaabfe320cb74f056a2e0b3fda37998f65255afe5367a79bf6d69e969d997321c46b63d5f3fa121dbf30061454e00b1dc7|
|[389-ds-base-1.4.3.21.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.21.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.21|[Building](building.html)|9fbfdbbbd5c89eb4f2463710aeea2563621426ea88fd9f23adf3cff2036940cabe12545efa5dd23337c87237a8a120c4d465a653d720fdc8140681cb94b5061c|
|[389-ds-base-1.4.3.20.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.20.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.20|[Building](building.html)|651c8d1d7a3c51b5a92542584bbfdde5a62c5bd7a1c09e6044bf1c6412f02244b34b252bf35e9c93bd696eeba1a741099015ad19d8d7358817d85cbf193630db|
|[389-ds-base-1.4.3.19.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.19.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.19|[Building](building.html)|dd1aa11a425e46adfe115c4aab033f4dd48157402432482b2f76f1d0698753d3438954d8c2d3e4701d073297a95db070d2fefeeed2f064f09a5baa700716888a|
|[389-ds-base-1.4.3.18.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.18.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.18|[Building](building.html)|554733d9e9182c805929fe5fc3513fdb8a4676db06f3f4aebf04e1070d5b0976dbc1f0ee886825607cba2e789beb6bd64362a62833b159747fc11328fcf61dc6|
|[389-ds-base-1.4.3.17.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.17.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.17|[Building](building.html)|2a789eac2db298032cfd96a7b158144cdf1abdb635cd26759d2cc62528cb6ae2984cf8874f33f265909d67500d094c0ee75043cbae989e2fb2857b6817ba51fe|
|[389-ds-base-1.4.3.16.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.16.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.16|[Building](building.html)|a5fc1dd74e19391cb49fa5c3c42b5ae6713a2edf1a04dc626ce065374d5a892defda8ffba642f9505c579de8208529372e9fed10a0374175b89247415b75dbdf|
|[389-ds-base-1.4.3.15.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.15.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.15|[Building](building.html)|c0f082d6c9426b6a8ec7e2d3067a7e840c51039dd5b5af5dc07ad20ebe07f4093ee03540f1c5ae60d4966aa0eeb8697ebb4cbbfee689c31ac2fac4aaddeb058c|
|[389-ds-base-1.4.3.14.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.14.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.14|[Building](building.html)|674434e18d1c96251462da113568fe8d76643982136d803e439d5c743c3592c053f172fdff96f20e432e7af5540b73eb77708721f385bddadcfe7693177fcd8a|
|[389-ds-base-1.4.3.13.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.13.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.13|[Building](building.html)|68713edfceb3787ec364ea96200b5beb14eb17871720fa1fca4bb7564426082f85a7e11eb438193dfa83f72f0a7a33eb94a370f833b973f4d020b6ceb023070e|
|[389-ds-base-1.4.3.12.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.12.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.12|[Building](building.html)|d8ab31e3d4d17d5a6debe14dbd5377a7070888dfb1e5783325526e22a59f905cac4877d4e4a621274b091ce2cd4d408016afccc3fc99a2a807ed56eef7b30223|
|[389-ds-base-1.4.3.11.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.11.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.11|[Building](building.html)|042caf889254471d5f310cf40d56cbe97d7632bf0421e2c0e9956cd3c7ed274f4288eb12e5cb548f7d1f7bf3a92523f14a5add83b858fbe3fc2d550c395d751b|
|[389-ds-base-1.4.3.10.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.10.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.10|[Building](building.html)|d4385e974b376d3a5c8b9a9e9b18c51114f2a6ccb8d4b0dfb32b3b4c7936e881c70afe60e94b1a25ca8395cc85ec55061ca85a48a1ad00e116a2e0ba3c4dc1a5|
|[389-ds-base-1.4.3.9.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.9.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.9|[Building](building.html)|f5e47282df7a4cb090d12894b8d85e71b4791e6a101de2b66e90d583e41d15efae4e2aa24c548fce576c130f0215ce16efcbac00a2d32dcc911ee2a19bd026eb|
|[389-ds-base-1.4.3.8.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.8.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.8|[Building](building.html)|31b69c85a4c346a5516e94b28af34154c654b2c2c395e503a5462bd553b4168688fccf652f2b6e7046c4805c665cc6a55d097c7d4af59e4ea2f240c3ca27a2ef|
|[389-ds-base-1.4.3.7.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.7.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.7|[Building](building.html)|0b86a303d428831a66da9b3a7198f548cac243970d65f4a67c32e82b16ac0a3d52d59ed881f19e9067922a100d709cdebedfffcd10aac5a326bf8b7c5cd6dcf6|
|[389-ds-base-1.4.3.6.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.6.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.6|[Building](building.html)|0f3cadb87fd642ff5cc2541c76ae627beb9c8f720b1e7ec1187bde2ec56f5c18d429bf053ab82f11def9eae51a73c980ec7786285d994c33b69a6c4bdee0e611|
|[389-ds-base-1.4.3.5.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.5.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.5|[Building](building.html)|b6af931a8aed7140220061b5d370880acce606901a0087ef8c22a51b16a111e0a13b4893ddd0166ec8a70ca4041f457b9890d137ae037cea2d3433dcc818a9cf|
|[389-ds-base-1.4.3.4.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.4.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.4|[Building](building.html)|013403f49000e80b42565191153fb0e535ff6b2cbd1fc9127fb917e2bd9379e57c5e7562259d47a72126761b642af87eb854058b842fc33077e98d6e123d556f|
|[389-ds-base-1.4.3.3.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.3.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.3|[Building](building.html)|63e241337d55cafbe71173bdff90d8668ade5f223ccb24e57f243a0406c8505a0e1e5fab6b11c06a36231a8c0d740ac8b018d5530e9355be802e2810d36da715|
|[389-ds-base-1.4.3.2.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.2.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.2|[Building](building.html)|e747c96428b0b79cbea6f01c07214b8ee3456b6f5d93fd27da905c56690e370925d70939765d68c43dd74ecd7121bfe61d84314b8127d83dded45186120caa5e|
|[389-ds-base-1.4.3.1.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.1.tar.bz2)|389-ds-base.git|389-ds-base-1.4.3.1|[Building](building.html)||

### 389 Directory Server 1.4.2

|Source tarball|git module|git tag|More Info|SHA512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.4.2.16.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.16.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.16|[Building](building.html)|fbe4f6ef22a829ebafcd3f961badfd588d1e18696cc7b27a3540433f137afe9446a615343ff102de889ad20498c94355807b4bbc55d0623d5d9ee6498997b0dd|
|[389-ds-base-1.4.2.15.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.15.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.15|[Building](building.html)|1a86563bdbad12d95bf8620074c45759d93415ee4a0bd78863b2a5fd0beaa9e99bf26aa8e0ef46417d092b896d02d62c961f79369ab5895b0c9a51f58af6058a|
|[389-ds-base-1.4.2.14.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.14.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.14|[Building](building.html)|dc8545fc79312f11e9978e7e3c94c2b1e63df1119fc3c3d4963df54b3cd88ec3632fa52d97c5d1d9243c76a36512d105be17f875d23d545e4af515300383826f|
|[389-ds-base-1.4.2.13.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.13.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.13|[Building](building.html)|77c9bc813ea6fefff2a48499b389a78804f3835d8e0fa07513986b4cece8d0634504a35609d7a78d8298d0dfa414315feaeb1c95341f4291ba19c59cfdc22bb2|
|[389-ds-base-1.4.2.12.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.12.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.12|[Building](building.html)|28879e2e09a7dd37dcb1aebc47ab050d64a3a3ac2137d05af53e7619d691b4e2536f9f02ea3682becce3672805d846944b839c3efc18e663e65a3bea9a442690|
|[389-ds-base-1.4.2.11.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.11.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.11|[Building](building.html)|472feb7208e2a8824eb16b40a880acb534b19be81f9675a623d10a3338c1b94a5f39139ce374db396fdb89aff16529ffcea562c602aaef04358ae8fc10400ab5|
|[389-ds-base-1.4.2.10.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.10.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.10|[Building](building.html)|5ffb72c4ff1b41542398a424748d4a06cf3734fea69160141de0c874627c0b19ee6567b9d0e4881014aabd4bdd0171450cc3fc8b737303677a2e2d823cb7fad0|
|[389-ds-base-1.4.2.9.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.9.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.9|[Building](building.html)|b5294eeb9cc66cab5fc716242db38c834d5412f475100915a9a381b8b4e8e84670e39036e9ae0d63ae8f3d6ab213186015e2ac0e60a4bc36adae5aadb8ee1d96|
|[389-ds-base-1.4.2.8.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.8.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.8|[Building](building.html)|7b9a3a678c6c01270cd5a543dba9e96d2d8e444a2de6e0b10b148d2b201716b3ad63cf8d6a6aa3ab330cb6ee1a69c1553aca8b78fa7977b9d8766c0b94df8de1|
|[389-ds-base-1.4.2.7.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.7.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.7|[Building](building.html)|7bbb5b8f3ca71c3bd3be8afb15a5923fb407fed920d3b6e8674232d825c500a7c9bba5d03dc281a9c54352688e7b2b82a0ff481fc84eea06f66ea760b96b2b2a|
|[389-ds-base-1.4.2.6.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.6.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.6|[Building](building.html)|54ec37d421f99a4093c44d5a5c0a31a0c2e93e1c43aaeb63560204437c8c7b4c72b644dfa39164120f4a4b64a0d4368b7a2e6264e389b5b27615c08447faf013|
|[389-ds-base-1.4.2.5.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.5.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.5|[Building](building.html)|46cdf18809466faa2104a3fd5aa16d2b0525bc73c7a517e167c85cb0d6d6078e78b20a865c2eafe4671e11a2f0c879b1f1292c10d8a3aeb20da769511d60542a|
|[389-ds-base-1.4.2.4.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.4.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.4|[Building](building.html)|b341bd55ef01b328b08de9dc88dca7dad7036064bda04469ebd650008ac4646395accacc32780bc7eab161a7fa5a8fa19f5511b827ab8a68b9c08dfc660969f1|
|[389-ds-base-1.4.2.3.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.3.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.3|[Building](building.html)|c717c10d171c12e74194c1a19e0de3f609f07858b3c73fc5545eb65953a69e2bed6bca910ea7b8a6f711dbb86139f419534515ea03e7ea908ef89684d4162974|
|[389-ds-base-1.4.2.2.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.2.tar.bz2)|389-ds-base.git|389-ds-base-1.4.2.2|[Building](building.html)|410f79de429d552286100744add6c7f2a01aca08a74e87fb3bdb3a5758476d9ab129a367ec457f3bceed4ae971d5c33cd4be36252cf074f4c3450d188b6d7df6|

### 389 Directory Server 1.4.1

|Source tarball|git module|git tag|More Info|SHA512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.4.1.19.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.19.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.19|[Building](building.html)|3aeb73d24dc3fcbb987514b374b3f0fa25c83893a6e97eeecaab598acf17de3201ca93bd7aa4e779073f7145cea95fd7017f73b0357a459b9df230bd8956ce8f|
|[389-ds-base-1.4.1.18.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.18.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.18|[Building](building.html)|0fa7abfdb328a4203ec2650592506faf19b013f7d4656297319b96d30234cf8aafb5efac7bb610d42de13bc233debe80f3c07a5946771f2fd2045445aabd2604|
|[389-ds-base-1.4.1.17.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.17.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.17|[Building](building.html)|63883a27444864ac58a1ade779233ea5f2645cc3717a5470161222464831e384e980f0d21b2730e5bbb423ed129c210863495ff9e22dab5a78e1bef60d2e44b6|
|[389-ds-base-1.4.1.16.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.16.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.16|[Building](building.html)|91b3bc4796361e318db42a0776a5424f89b2c6b71b0b376a30fe589cd1fcf6474c7b1291ee78945a212bd564b4e126746c3f7806dbdd4f9462b4c86d75a35357|
|[389-ds-base-1.4.1.15.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.15.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.15|[Building](building.html)|b7e05675f791776931d631a92810bf4b22760079fafeae405352fad5a7db1b3e8cb1857c8b319eeecf67cd527c7b374c1bae72b6b6b782c62224bc1e7e6b90d7|
|[389-ds-base-1.4.1.14.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.14.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.14|[Building](building.html)|6022ca2cd5862a52ff8d4a0e57ddad7f1780270b7a37de2daccb9bd32bc7d0be9fdefa4cfca9b12f6a577addabf82c7e31b3bd557c27ac469beaa928e1df59ee|
|[389-ds-base-1.4.1.13.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.13.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.13|[Building](building.html)161368289f13e8f6a448dc5e6aadd129724ef6b54efbb66c8a03b46a1aa424157d27c53c6b779dc47f81506ba834bec66a9bdef072fe5f50cf73e1b68d723511|
|[389-ds-base-1.4.1.12.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.12.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.12|[Building](building.html)|ea238be1d19b1395e73842a529aa966bd35b93bb9f9bc3dd36f5df7fc3ec4c2dcce108ee25b4ce395fb11080027a2475939b0807c8691359dae05659836349a2|
|[389-ds-base-1.4.1.11.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.11.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.11|[Building](building.html)|a7fc27de18a63438546f14581b43a9ee0ddb3049e2137b206963a692b15efce16025139b725b8cc2d58d8ddd7eec43b04b32e4720d8a862a7e4f2c94f96b186d|
|[389-ds-base-1.4.1.10.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.10.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.10|[Building](building.html)|f04b99cdfc43d9e94ca43f098e17fe20df3ceb39d30b730506e0f24d7e645c7c6e78cb30870bf800288b204ff6ab51327ea200f1ea337cc19817938204b9480b|
|[389-ds-base-1.4.1.9.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.9.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.9|[Building](building.html)|d9fba8577354b2b5651a0b42dd26338c26996133b5a3916974d88493974b77bb155684d04de26c3f47a9b337eb3000c0e08ab0eb002ed64b18d6e3e0f6966217|
|[389-ds-base-1.4.1.8.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.8.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.8|[Building](building.html)|d7adf184b85cf5f8908794b044f9547fc2e3b67299d3db4bcc824b6f9f68b34a593b91ff167d55d83c317bf4f71c9ae7506f0fb7185e4e76101696e643cff673|
|[389-ds-base-1.4.1.7.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.7.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.7|[Building](building.html)|073b0620622410738c6c6d6f765ef9fca4350478f456bc96f42d0daf0e36de906348101939cce484c2d4a7dd974fe4bd1b10594b0155eba91dfd54264f38c55c|
|[389-ds-base-1.4.1.6.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.6.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.6|[Building](building.html)|0a943453cbcd8b43b4fdc58563c8802d9270d9a3cf4dcd76e3f77168d45e84b8e07d8df8ddadb09ba9294e7ba7e9304ce329bc37edeb16a9161797c902fadc1c|
|[389-ds-base-1.4.1.5.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.5.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.5|[Building](building.html)|b70a91441111d57481b298cb6c3d4a8c7182e7f74e2127079b162c47b817940e6be8586932626a521245e4b52d696fd3c4d32c7ad6f660d96d15f1a97114ce13|
|[389-ds-base-1.4.1.4.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.4.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.4|[Building](building.html)|d9e410d4be72dfbdfe151ad89cf6c6d99154f91b933265eb521b06023f89ee6d0928e3eb7edd99c6111e59aab8dbaf6979aa9c5c897c839a5f7905f772ac1474|
|[389-ds-base-1.4.1.3.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.3.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.3|[Building](building.html)|d7c1e3e6b90b07f87820117b0c3fc77a17ef80d2502decec33e1f0541da9635ff4a6f23ace621bd9a7512de7fe3c6d39aa99d62a67f0748a39cc66a2057789cc|
|[389-ds-base-1.4.1.2.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.2.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.2|[Building](building.html)|061dc2c814b091e779ecd9f97b74dcc2445ca416b781b3a82d197a25a12fe2f4b4da1ddf647f434d3cf13981c187b9c96c612f5c53ea5cebe8f7bfa38116ee8b|
|[389-ds-base-1.4.1.1.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.1.tar.bz2)|389-ds-base.git|389-ds-base-1.4.1.1|[Building](building.html)|ba32f0923cb9e45f86cc17086ed4d362f274bb7ca49a43e647eb04e78128c3610c881db7426e256ccb082ac0a5dc598436b2437d068212182c0823e2fb3859dc|

### 389 Directory Server 1.4.0

|Source tarball|git module|git tag|More Info|SHA256SUM / SHA512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.4.0.31.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.31.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.31|[Building](building.html)|519d6fbd2b78732e6d2f4588ad556f6cd9083f11a56aed8c2b0cb836ae481c10bd19f2a8296aaa9213e089512428e4e7cec802dfcd3717111085d21ef422f332/
|[389-ds-base-1.4.0.30.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.30.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.30|[Building](building.html)|518184e1e677591583fc247f4759ae3ac1fbf26e327272d38e5c36daf5c87c7e4d0038e4fad9d248577ac6582a1ca3012e8892e69f5311f873621e1cf6e8dac1|
|[389-ds-base-1.4.0.27.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.27.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.27|[Building](building.html)|362010349dfa6d8d8a7a20652eff43a0e99c762b950cce76e604b5c2285eca6b8361df88463f781556af55a7708ac4394a59b0d4fb8e305fcaa62df76c89db92|
|[389-ds-base-1.4.0.26.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.26.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.26|[Building](building.html)|66efaa4427f332b0d8c81a07a551b42e1c0947167db2ef4197407a2e78649a800f00c8fdd2e98144ce54496b70d876f62a0aad3c595f4ef6efce19ad341fe925|
|[389-ds-base-1.4.0.25.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.25.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.25|[Building](building.html)|c444c3dbe44705da435fe165d9b41323ce4aea1fa2a5574e98c6672307cbef00fdf158b4e7ff4cdf0ec7e416aaee2747deb02248c8032c9d42221d742bacf5b3|
|[389-ds-base-1.4.0.24.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.24.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.24|[Building](building.html)|68d701fca940e32a03f580042c4a908265d883bcabac9d91fa2dbe0b030568788610ed25bf58f07873980f5e24eeeda65a306c5ba29d5436c4157b5ec816eafb|
|[389-ds-base-1.4.0.23.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.23.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.23|[Building](building.html)|e19f243c7dbb86606422d47111839afefb560a3b8de66f902e90f3271ba6555a5caa60f45b5362692797661d7ad35659adabd942e1ecaf75c0aa4562c921653f|
|[389-ds-base-1.4.0.22.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.22.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.22|[Building](building.html)|f2d965f657b4793ae66c29da9fe736c8a91307e2e062c25d0231cc0dfae96e5ee5b3e3691ca796af2971be3b7e3aef9fd9b2cc47813b6848a7acebda99ad7ee1|
|[389-ds-base-1.4.0.21.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.21.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.21|[Building](building.html)|83bc1dec7b11b05f0ed0a917c1ef8aac268ef9178f1f87aebddbdc0201c5c014ad07143a34b6de06e0fcd9c3642aa306110b29502c03522f89796268beeca686|
|[389-ds-base-1.4.0.20.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.20.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.20|[Building](building.html)|bcd22f64b7e29a0d58dc19c428eaabb3674b5f2a6029f62eeadf4e21346bcb79e689d91e2689d01b625d731cac8b49150343975961a52c1552d2454038598c20|
|[389-ds-base-1.4.0.19.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.19.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.19|[Building](building.html)|8ae906bd30bf646f2b157fd259b0f92ed6cdba47f44e0c928cf9cb10529858464616b11bab9301e9c51bae139b1c3fe9131694217ce99901b0e8fd3421329b62|
|[389-ds-base-1.4.0.18.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.18.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.18|[Building](building.html)|ac658801fe3343b48947b1a2599dde173e2850f54873ccb04862c5b166333bcc0967b4e4dde52d94dd1ce216fd81f55ed4505a47799b04d9dadba7d006deffe3|
|[389-ds-base-1.4.0.17.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.17.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.17|[Building](building.html)|d18b048c300a4d64f3c3bcc866364074ec574a78a0937bd2ca2809d577a5a1d9af720e102f18edd8a384f36bba8a65dca971ce7f899af76be5e4067599330f7e|
|[389-ds-base-1.4.0.16.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.16.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.16|[Building](building.html)|c958ef8fe0329f099f5cc21937fe81cfb78be093093c07d19c87ab32ccfcfbacbe924d9e1705d4f3d5df827e6821fd1917fc8906b3a39feb531aa897269ceab0|
|[389-ds-base-1.4.0.15.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.15.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.15|[Building](building.html)|6b9c06d687b31d5e48829436727995a0e29ddd170cff7e56240910b0a63f30796dd144e0676ca08b592480e91d622cae7f2a74b5ae92a698ff95b8576f01640d|
|[389-ds-base-1.4.0.14.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.14.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.14|[Building](building.html)|b23c785c88347901cb006c3aa9dc81d190c9ca85cf3b65a1cf4dfbd3f4e050cd1b1448f32a9a8ad4b96fb6cc5f5bc55a67a4857adc4cd4dc6bea014bb8d5f1c7|
|[389-ds-base-1.4.0.13.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.13.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.13|[Building](building.html)|6f2014b069b1bf62ff297a41551a9c681b4a3dfead881a483781a827404034272e68ad3173c89d047eed58d894aa64be73da2f483bf20970f295ace7e614f8a8|
|[389-ds-base-1.4.0.12.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.12.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.12|[Building](building.html)|4d14db63bb6d61b08f395368b953d5eb8c3c8d3d9a6ab7b25cfb18b8dcefe1607ec8f7842afe6e798da04985f2e026ea9c82cae229266047e555eeca39027c28|
|[389-ds-base-1.4.0.11.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.11.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.11|[Building](building.html)|f62352f8d3ffbde21ca91f5a245b4e227638ecc9aacd005438c53f19d954ca8a306a514e6217fa5662244b64f3f228e04de231eee116c847baf1ddb69ee459ab|
|[389-ds-base-1.4.0.10.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.10.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.10|[Building](building.html)|30250c4e72f03e0ea725767c3281f2f33b298f5bcee2af7b51a35a59a566c5cf7a52010ec46069d803cb99a2a01b6a8f7b09ed2dda85a17c4f42cf47f77dbde7|
|[389-ds-base-1.4.0.9.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.9.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.9|[Building](building.html)|048936e10cdc5a0de2f4d488a05e3c826b6479e1d5fd15bf31582b5534c70186b93758c083184d4f0330dd9164b95c28dfc82bed484ff904301f4b5148a35fcb|
|[389-ds-base-1.4.0.8.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.8.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.8|[Building](building.html)|26ccc00b9f436c33517e8493442c8ee806bced59784ed3abed9d6904559bc990|
|[389-ds-base-1.4.0.7.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.7.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.7|[Building](building.html)|ca76e2c4b8a83d82bd80499542e8fdf03c50952342cc4c0bd58dbf4503f2351a|
|[389-ds-base-1.4.0.6.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.6.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.6|[Building](building.html)|a9f9a3364b1f167cc4f6da353e31f8efbb2300f0e432c11616db4bba61103192|
|[389-ds-base-1.4.0.5.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.5.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.5|[Building](building.html)|4a2e6359abfc4c23ef5f13374bdb9c27d7a2d026a1a9f194d2562dc91d641448|
|[389-ds-base-1.4.0.4.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.4.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.4|[Building](building.html)|a0ea02fc3f7f808dcf1eda4a35df2cfc639e035283c2d6ce03c010b2794434e1|
|[389-ds-base-1.4.0.3.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.3.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.3|[Building](building.html)|7aeb387b8df4fa06c66baacc09f05d7fa7b9a0f69350a41576f095a2b12ea180|
|[389-ds-base-1.4.0.2.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.2.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.2|[Building](building.html)|65bdf20ccdcb949c01ca4e0ce0db84313f97cee2e2020714bff0eb50595a487c|
|[389-ds-base-1.4.0.1.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.1.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.1|[Building](building.html)|fa4ea2ab3467ed14e8259d40dc2e5c2b0d1d42269929ff0a72ea7199043c0f1e|
|[389-ds-base-1.4.0.0.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.0.tar.bz2)|389-ds-base.git|389-ds-base-1.4.0.0|[Building](building.html)|d557e44959ec9e11f08350c4d2a5753b05a2b1582c399a640f3359bca539ca79|


### 389 Directory Server 1.3.10 ###
|Source tarball|git module|git tag|More Info|SHA512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.10.1.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.10.1.tar.bz2)|389-ds-base.git|389-ds-base-1.3.10|[Building](building.html)|48014ecc67984dcd362854fc603064c21cda892368c18cb01744ea4d5bb4fdb778075598337a91e6181830a0a1b8d9c017cb5729b935faaa916b9d96d213a22c|

### 389 Directory Server 1.3.9 (rebased from 389-ds-base-1.3.8.10)

|Source tarball|git module|git tag|More Info|SHA512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.9.1.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.9.1.tar.bz2)|389-ds-base.git|389-ds-base-1.3.9.1|[Building](building.html)|c486149884b73561443dadcd2461b26e1af2084b090815f9e3ac6a3f0a20ccc9d94a8b320148dfab51dbe765f3329f0f6ca60723c73820d25f903a998b6827cd|
|[389-ds-base-1.3.9.0.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.9.0.tar.bz2)|389-ds-base.git|389-ds-base-1.3.9.0|[Building](building.html)|9804efc6991575771394ce63b4f177ba8bcb89f45ff60216b39cabee63b2234b8502a4d1587830ad6422ea68d58a4b26a55e2124f4777eeaa20beef92f9e7ee1|

### 389 Directory Server 1.3.8 (rebased from 389-ds-base-1.3.7.10)

|Source tarball|git module|git tag|More Info|SHA512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.8.10.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.10.tar.bz2)|389-ds-base.git|389-ds-base-1.3.8.10|[Building](building.html)|8b50cd8d81694cacef5e7992b82e9672fa6df071f097929f040692cf6bd61291b1125c082eae7a36afbab60491095eb5b4f7b6bd0a7332311df30a5ac62c0784|
|[389-ds-base-1.3.8.9.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.9.tar.bz2)|389-ds-base.git|389-ds-base-1.3.8.9|[Building](building.html)|2f07fa3786ad134afe702bac3c28ae3e6bdf5b944f95ff343e5310a3425ecb81e37b5c2d7fa51066caf2e10a5ffab2ad80f46468fa8e008e36931d0a9d6b8401|
|[389-ds-base-1.3.8.8.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.8.tar.bz2)|389-ds-base.git|389-ds-base-1.3.8.8|[Building](building.html)|632456d318282a849f20e4423561825b09fee53f2471898ed787421a3e9aeb3639ad2c5562ee2389f034e07138eb936db8ca1f56f5ff210da32690407ffa3db8|
|[389-ds-base-1.3.8.7.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.7.tar.bz2)|389-ds-base.git|389-ds-base-1.3.8.7|[Building](building.html)|5fa84cc2f12b7d4c5ac48927549315aead9947991f89226ec5a28a099a443daadba281b355507a2fee2140e9840c80b4e67cd829ae94a48fd097c283c7453ea3|
|[389-ds-base-1.3.8.6.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.6.tar.bz2)|389-ds-base.git|389-ds-base-1.3.8.6|[Building](building.html)|c5fc70c51839742f7d773ab8144ecea70101d115eb96893a34f17f499fc34c523a90506c39517d07f5b2b82863ffedd17228fe8878b84fdb6ef60a7089821ab4|
|[389-ds-base-1.3.8.5.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.5.tar.bz2)|389-ds-base.git|389-ds-base-1.3.8.5|[Building](building.html)|ec0421a6c4501ae8ecb452a6976c42a54e6d499dea8e4580439c194a9968fc772198dfe347d2c64cbd80bfea162f14125b24afaed9abfa83599512f601f7868a|
|[389-ds-base-1.3.8.4.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.4.tar.bz2)|389-ds-base.git|389-ds-base-1.3.8.4|[Building](building.html)|0333064624f3cead72252379622e6c8ce20671b8a281ab6839a6c7a3c0f82a943573504240717938ebe66422e77ec2eac80095d411fb345366af7e7fcb0c9f35|
|[389-ds-base-1.3.8.3.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.3.tar.bz2)|389-ds-base.git|389-ds-base-1.3.8.3|[Building](building.html)|32e064fc43259a87e0d258719178ed40ea331b08d3f993eab1afcd21357ec79bbe0e0d4cb7184f8b66f58aed5223ed6581c75e91691343526c958eca3781bb76|
|[389-ds-base-1.3.8.2.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.2.tar.bz2)|389-ds-base.git|389-ds-base-1.3.8.2|[Building](building.html)|91e417c9ec097c63e0af12f70702bdeb37df3b5d9503da4041c873caefc20a33a9ef841a7f8ace7ab29dbae4e2b8f47f959f1933b2ff565a22feffc5cfe519e2|
|[389-ds-base-1.3.8.1.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.1.tar.bz2)|389-ds-base.git|389-ds-base-1.3.8.1|[Building](building.html)|c4a5dd631a2096c8021498124a9f9a5e0af8676e26620dfb0d64bc9ff3d0fb16e5e305e137d58e842249f402a42e920251500eee6b08e555fa16d6b92ca87c04|


### 389 Directory Server 1.3.7

|Source tarball|git module|git tag|More Info|SHA256SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.7.10.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.10.tar.bz2)|389-ds-base.git|389-ds-base-1.3.7.10|[Building](building.html)|d177aaee49be638e6ec4501d2409b71cc34faf67db0d7a11b67d2891e7bcc8e7|
|[389-ds-base-1.3.7.9.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.9.tar.bz2)|389-ds-base.git|389-ds-base-1.3.7.9|[Building](building.html)|fe9e7bee67ff6ce8b41d7e7c74dae79bd69711bcb488fe8c226e218357331e37|
|[389-ds-base-1.3.7.8.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.8.tar.bz2)|389-ds-base.git|389-ds-base-1.3.7.8|[Building](building.html)|7f7bd56c05059add1c386fd48bad1324756b142b60c3ba0364736261aba200a0|
|[389-ds-base-1.3.7.7.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.7.tar.bz2)|389-ds-base.git|389-ds-base-1.3.7.7|[Building](building.html)|6353f1e7578daa18a3816fd5028c5b6df4f29d6ce43be6b524316f6f8e3f10a3|
|[389-ds-base-1.3.7.6.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.6.tar.bz2)|389-ds-base.git|389-ds-base-1.3.7.6|[Building](building.html)|7236e71489b832f9e13d2b2f8b5a93060dc0e0ff92fb35a0d39641bae020a769|
|[389-ds-base-1.3.7.5.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.5.tar.bz2)|389-ds-base.git|389-ds-base-1.3.7.5|[Building](building.html)|007ce281d2961ed7139d90c6fe38d7fbe532d7b46589bca1ec7465d57229dfc9|
|[389-ds-base-1.3.7.4.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.7.4.tar.bz2)|389-ds-base.git|389-ds-base-1.3.7.4|[Building](building.html)|bc5021b37c240a848f9567b31dc91ee7e8dea564360cceedf42a962a910aee5e|
|[389-ds-base-1.3.7.3.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.7.3.tar.bz2)|389-ds-base.git|389-ds-base-1.3.7.3|[Building](building.html)|ccbbee067142a8c7e005a57e6b0eb2df8b7581b02ccce4e6d4c86b89b71f1d69|
|[389-ds-base-1.3.7.2.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.7.2.tar.bz2)|389-ds-base.git|389-ds-base-1.3.7.2|[Building](building.html)|dbbf2dcc76a6cf2527a1a59f3bf4315717e233e321a9d3ee1cdf67e17ab33e48|
|[389-ds-base-1.3.7.1.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.7.1.tar.bz2)|389-ds-base.git|389-ds-base-1.3.7.1|[Building](building.html)|3f5b85988f2d5c17c4c3f021593863f1798a32b43d594c08163a06bf3d5ed2fe|


### 389 Directory Server 1.3.6

|Source tarball|git module|git tag|More Info|SHA256SUM / SUM512SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.6.15.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.15.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.15|[Building](building.html)|7fd7ad2f03b7cb55897f546d916db1380c9445ab67b7f6a5de1e1638b27f2cd676859e282b7d9baa551c172db71051d6d6330311d5d63b9cb99f1699f6e0dce3|
|[389-ds-base-1.3.6.14.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.14.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.14|[Building](building.html)|2a34d64255a20cfaf920b98a23e532e0f9257dbe68227b15494cf4f58b4fd672e4b8d5c3d2ed79dff3910376c66278b5dad4594658835a28f7957c96bc19b919|
|[389-ds-base-1.3.6.13.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.13.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.13|[Building](building.html)|524744dc5afa37409e22684a71f603dec094f7b37d9d053390eff1617b278f61|
|[389-ds-base-1.3.6.12.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.12.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.12|[Building](building.html)|746eaf134d4dd2bdf51ee3d2a05a6f71e5e2fcbcd31f22892aa714d0b1d7f454|
|[389-ds-base-1.3.6.11.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.11.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.11|[Building](building.html)|fb931af243d8764349e609b9893dde05886cee8d53708beb0e8130a1ef70e603|
|[389-ds-base-1.3.6.10.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.10.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.10|[Building](building.html)|866ac60a4c38184505a97762132f77800525b136fd071c19cf054b7d0b4bad0e|
|[389-ds-base-1.3.6.9.tar.bz2](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.9.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.9|[Building](building.html)|246b533b65d7202635c60afb625244645ecb15ec1d0fe0f882a36308989a23ec|
|[389-ds-base-1.3.6.8.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.8.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.8|[Building](building.html)|447997455d0b9cf97c9bb86f23066d119c73c3a12b473fa45b4f1a8299d50e8a|
|[389-ds-base-1.3.6.7.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.7.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.7|[Building](building.html)|d6a8a4dbe1ebd30eff2ad20f550fe2e1b2673ca632cbfbee46baaff2671062db|
|[389-ds-base-1.3.6.6.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.6.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.6|[Building](building.html)|d1f2e3f8a44bb035b2724aa2dc5c7d7b751fbe305f935a4377dea821dad1be94|
|[389-ds-base-1.3.6.5.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.5.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.5|[Building](building.html)|a0bcdcb6231399c507a7d28c3282fe2bb226bea39ee1a7b2604aeae88059a797|
|[389-ds-base-1.3.6.4.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.4.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.4|[Building](building.html)|e370270391d9e4bac4eb969380f76fbc715886a8f0b156433fee932d2701fbedd8f0460369a2878dd8f134ac5f35393ea2ea76b25cb24e91b744c1de2af3d879|
|[389-ds-base-1.3.6.3.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.3.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.3|[Building](building.html)|bd45bc424d58e91d0855f075614ff3cdd99be9b517789743c44f6d6a025aecce|
|[389-ds-base-1.3.6.1.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.1.tar.bz2)|389-ds-base.git|389-ds-base-1.3.6.1|[Building](building.html)|a814776ce153dd75e86ebcc7bbf4106ef1ee7492bcccf41c2eb5b984de31a48a|
|[svrcore-4.1.2.tar.bz2]({{ site.binaries_url }}/binaries/svrcore-4.1.2.tar.bz2)|svrcore.git|4.1.2|[Building](building-svrcore.html)|67e51a868c8dc2ddbf5661ecb0a07dea7721a9ed99f6261cedd3351bfc4cd023|


### 389 Directory Server 1.3.5

|Source tarball|git module|git tag|More Info|SHA1SUM/SHA256SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.5.19.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.19.tar.bz2)|389-ds-base.git|389-ds-base-1.3.5.19|[Building](building.html)|ad55aadd4155cabdb7cc66dbca3bbe43faf865750da01032c9a1f8ed3a2136e4|
|[389-ds-base-1.3.5.18.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.18.tar.bz2)|389-ds-base.git|389-ds-base-1.3.5.18|[Building](building.html)|cf86bbeb21096d3d5dc51398790a74ed8c8f7aefbb54c233f4962b0c99216997|
|[389-ds-base-1.3.5.17.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.17.tar.bz2)|389-ds-base.git|389-ds-base-1.3.5.17|[Building](building.html)|5b96b19cea7dc80c64eaade31127d04c228f7e4dc1999ec19b341cf080ee4570757c84e8dae151c2cb3bcebe1398d50238d74ca362ce07fceafcb66fba590833|
|[389-ds-base-1.3.5.16.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.16.tar.bz2)|389-ds-base.git|389-ds-base-1.3.5.16|[Building](building.html)|29cdd0066447a0de9b5455444a2020a9d1a0aca8|
|[389-ds-base-1.3.5.15.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.15.tar.bz2)|389-ds-base.git|389-ds-base-1.3.5.15|[Building](building.html)|856753525d074c36acdba087880f68edb0236211|
|[389-ds-base-1.3.5.14.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.14.tar.bz2)|389-ds-base.git|389-ds-base-1.3.5.14|[Building](building.html)|9c81ce4093790dfa31ca9eba1ebbf10f024e7684|
|[389-ds-base-1.3.5.13.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.13.tar.bz2)|389-ds-base.git|389-ds-base-1.3.5.13|[Building](building.html)|cef01f8347c3164f14089b4f647b9e986ef667cd|
|[nunc-stans-0.1.8.tar.bz2]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2)|nunc-stans.git|0.1.8|[Building](building.html)|835c9788650d1b9ef0896c267b06b9e529612835|
|[svrcore-4.1.2.tar.bz2]({{ site.binaries_url }}/binaries/svrcore-4.1.2.tar.bz2)|svrcore.git|4.1.2|[Building](building.html)|699db1b2294e7d15c8f576037fc5ff9bc6d8e001|

### 389 Directory Server 1.3.4

389-ds-base uses git repo https://github.com/389ds/389-ds-base.git branch 389-ds-base-1.3.4 (branched 19-Jun-2015)

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.4.15.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.15.tar.bz2)|ds.git|389-ds-base-1.3.4.15|[Building](building.html)|d453f6a982253d96efa4f616089b600331d5c740|
|[389-ds-base-1.3.4.14.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.14.tar.bz2)|ds.git|389-ds-base-1.3.4.14|[Building](building.html)|3c45f7a97b5c8c5475370df9efc8797a7346ff44|
|[nunc-stans-0.1.5.tar.bz2]({{ site.binaries_url }}/binaries/nunc-stans-0.1.5.tar.bz2)|nunc-stans.git|0.1.5|[Building](building.html)|7e52309f61c38b241fcdaf0284559d683f3ba700|
|[389-admin.1.1.42.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.42.tar.bz2)|admin.git|389-admin-1.1.42|[Admin](../administration/adminserver.html)|3d931830ce832b7e0f820689ca30e5996b873f75|
|[389-adminutil-1.1.22.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.22.tar.bz2)|adminutil.git|389-adminutil-1.1.22|[AdminUtil](../administration/adminutil.html)|ee337a293409b9682f68797bf200ef4a7e14c3e1|
|[389-console-1.1.9.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.9.tar.bz2)|console.git|389-console-1.1.9|[Building Console](buildingconsole.html)|bcc15330156beab1dab57cedef838f8ec5b26988|
|[389-ds-console-1.2.12.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.12.tar.bz2)|ds-console.git|389-ds-console-1.2.12|[Building Console](buildingconsole.html)|e71273413d9375d2b0713f18f69d48ad859603b7|
|[389-admin-console-1.1.10.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.10.tar.bz2)|admin-console.git|389-admin-console-1.1.10|[Building Console](buildingconsole.html)|3f79901cb5457220e34480032cfcc14879dbbb68|
|[idm-console-framework-1.1.14.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.14.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.14|[Building Console](buildingconsole.html)|fd6be1df38d8c1182b16b5f9d603860ce8cc1c9c|

### 389 Directory Server 1.3.3

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.3.3 (branched 21-AUG-2014)

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.3.14.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.14.tar.bz2)|ds.git|389-ds-base-1.3.3.14|[Building](building.html)|4b5d6db460b903a5073dc3e6086dec199f839049|
|[389-admin.1.1.42.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.42.tar.bz2)|admin.git|389-admin-1.1.42|[Admin](../administration/adminserver.html)|3d931830ce832b7e0f820689ca30e5996b873f75|
|[389-adminutil-1.1.22.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.22.tar.bz2)|adminutil.git|389-adminutil-1.1.22|[AdminUtil](../administration/adminutil.html)|ee337a293409b9682f68797bf200ef4a7e14c3e1|
|[389-console-1.1.9.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.9.tar.bz2)|console.git|389-console-1.1.9|[Building Console](buildingconsole.html)|bcc15330156beab1dab57cedef838f8ec5b26988|
|[389-ds-console-1.2.12.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.12.tar.bz2)|ds-console.git|389-ds-console-1.2.12|[Building Console](buildingconsole.html)|e71273413d9375d2b0713f18f69d48ad859603b7|
|[389-admin-console-1.1.10.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.10.tar.bz2)|admin-console.git|389-admin-console-1.1.10|[Building Console](buildingconsole.html)|3f79901cb5457220e34480032cfcc14879dbbb68|
|[idm-console-framework-1.1.14.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.14.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.14|[Building Console](buildingconsole.html)|fd6be1df38d8c1182b16b5f9d603860ce8cc1c9c|

### 389 Directory Server 1.3.2

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.3.2 (branched 1-OCT-2013)

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.2.27.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.2.27.tar.bz2)|ds.git|389-ds-base-1.3.2.27|[Building](building.html)|dc6bcbd97923dec7ff13a6437a07246723b6feff|
|[389-dsgw-1.1.11.tar.bz2]({{ site.binaries_url }}/binaries/389-dsgw-1.1.11.tar.bz2)|dsgw.git|389-dsgw-1.1.11|[DSGW\_Building](../administration/dsgw-building.html)|6a2b94be7d4f0079dbe5e84d720ff8f5e1779aba|
|[389-admin-1.1.38.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.38.tar.bz2)|admin.git|389-admin-1.1.38|[Admin](../administration/adminserver.html)|52f43945a6786f83009e5745c98b2c24f42f2797|
|[389-adminutil-1.1.21.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.21.tar.bz2)|adminutil.git|389-adminutil-1.1.21|[AdminUtil](../administration/adminutil.html)|7a78b262d966897e78a3c94f1ae9e7126ea53f9f|
|[389-console-1.1.9.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.9.tar.bz2)|console.git|389-console-1.1.9|[Building Console](buildingconsole.html)|bcc15330156beab1dab57cedef838f8ec5b26988|
|[389-ds-console-1.2.10.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.10.tar.bz2)|ds-console.git|389-ds-console-1.2.10|[Building Console](buildingconsole.html)|c4f38cd421ffcc8b26fd841e4e45096bbaf21451|
|[389-admin-console-1.1.10.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.10.tar.bz2)|admin-console.git|389-admin-console-1.1.10|[Building Console](buildingconsole.html)|3f79901cb5457220e34480032cfcc14879dbbb68|
|[idm-console-framework-1.1.9.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.9.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.9|[Building Console](buildingconsole.html)|38f79c7248106738ed10beca936eb85b40249a8f|

### 389 Directory Server 1.3.1

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.3.1 (branched 13-FEB-2013)

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.1.22.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.1.22.tar.bz2)|ds.git|389-ds-base-1.3.1.22|[Building](building.html)|671536bc70633e802b401c69d76da06e09e04ae0|
|[389-adminutil-1.1.18.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.18.tar.bz2)|adminutil.git|389-adminutil-1.1.18|[AdminUtil](../administration/adminutil.html)|054a9e06e91e1e0d8f88903cbcf8e7ab8b270589|

### 389 Directory Server 1.3.0

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.3.0 (branched 11-DEC-2012)

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.0.9.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.0.9.tar.bz2)|ds.git|389-ds-base-1.3.0.9|[Building](building.html)|45d9ccdaac75e7702de68d0972a27d39fefc67e9|
|[389-ds-base-1.3.0.3.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.3.0.3.tar.bz2)|ds.git|389-ds-base-1.3.0.3|[Building](building.html)|39f2b96bd6d6760af07780157efecc661d0e88c0|
|[389-admin-1.1.31.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.31.tar.bz2)|admin.git|389-admin-1.1.31|[AdminServer](../administration/adminserver.html)|bbfc6313db39bb55fa1cbd03fca8fffdcff286ae|
|[389-adminutil-1.1.18.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.18.tar.bz2)|adminutil.git|389-adminutil-1.1.18|[AdminUtil](../administration/adminutil.html)|054a9e06e91e1e0d8f88903cbcf8e7ab8b270589|
|[389-dsgw-1.1.10.tar.bz2]({{ site.binaries_url }}/binaries/389-dsgw-1.1.10.tar.bz2)|dsgw.git|389-dsgw-1.1.10|[DSGW\_Building](../administration/dsgw-building.html)|f147769e82187b570eb3e39b3a9fb1572bdd4512|
|[winsync-1.1.4.tar.bz2]({{ site.binaries_url }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html)|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.7.tar.bz2)|console.git|389-console-1.1.7|[WindowsSync](../howto/howto-windowsconsole.html|87ae48c131b2964f9dac97e011a8a8fb61d3a8a4|
|[idm-console-framework-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.7.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.7|[buildingconsole.html](buildingconsole.html)|2081dea597c2fe0078a8a8f4047884cb1e02e470|
|[389-ds-console-1.2.7.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.7.tar.bz2)|ds-console.git|389-ds-console-1.2.7|[DirectoryConsole](buildingconsole.html#ds-console)|21ed7ce7b2a2c0a529d251bbd33435d60a93a4fa|
|[389-admin-console-1.1.8.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.8.tar.bz2)|admin-console.git|389-admin-console-1.1.8|[AdminConsole](buildingconsole.html#admin-console)|8e093715b215e64ae9b307bc96df55d2bd496da8|

### 389 Directory Server 1.2.11

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.2.11

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.11.29.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.2.11.29.tar.bz2)|ds.git|389-ds-base-1.2.11.29|[Building](building.html)|ad392648f8dfa66c8a6d9d6843e1d10a3d518ae6|
|[389-admin-1.1.30.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.30.tar.bz2)|admin.git|389-admin-1.1.30|[AdminServer](../administration/adminserver.html)|971fb47a5d97cd32b6820f0f4cb99c196165dd0f|
|[389-adminutil-1.1.15.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.15.tar.bz2)|adminutil.git|389-adminutil-1.1.15|[AdminUtil](../administration/adminutil.html)|bbf4219b55bb1af0a76bb75bb16af4121b36f4de|
|[389-dsgw-1.1.10.tar.bz2]({{ site.binaries_url }}/binaries/389-dsgw-1.1.10.tar.bz2)|dsgw.git|389-dsgw-1.1.10|[DSGW\_Building](../administration/dsgw-building.html)|f147769e82187b570eb3e39b3a9fb1572bdd4512|
|[winsync-1.1.4.tar.bz2]({{ site.binaries_url }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.7.tar.bz2)|console.git|389-console-1.1.7|[WindowsSync](../howto/howto-windowsconsole.html|87ae48c131b2964f9dac97e011a8a8fb61d3a8a4|
|[idm-console-framework-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.7.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.7|[buildingconsole.html](buildingconsole.html)|2081dea597c2fe0078a8a8f4047884cb1e02e470|
|[389-ds-console-1.2.6.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.6.tar.bz2)|ds-console.git|389-ds-console-1.2.6|[DirectoryConsole](buildingconsole.html#ds-console)|adc763187f6b2e7f9f347b930276ab5712eb7807|
|[389-admin-console-1.1.8.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.8.tar.bz2)|admin-console.git|389-admin-console-1.1.8|[AdminConsole](buildingconsole.html#admin-console)|8e093715b215e64ae9b307bc96df55d2bd496da8|

### 389 Directory Server 1.2.10

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.2.10

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.10.14.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.2.10.14.tar.bz2)|ds.git|389-ds-base-1.2.10.14|[Building](building.html)|8de0e6c9d77041d48927200c42f5400645672db1|
|[389-admin-1.1.29.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.29.tar.bz2)|admin.git|389-admin-1.1.29|[AdminServer](../administration/adminserver.html)|6cdb023dadd0862327fd09f06f6a51454ff8672c|
|[389-adminutil-1.1.15.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.14.tar.bz2)|adminutil.git|389-adminutil-1.1.15|[AdminUtil](../administration/adminutil.html)|bbf4219b55bb1af0a76bb75bb16af4121b36f4de|
|[389-dsgw-1.1.9.tar.bz2]({{ site.binaries_url }}/binaries/389-dsgw-1.1.9.tar.bz2)|dsgw.git|389-dsgw-1.1.9|[DSGW\_Building](../administration/dsgw-building.html)|8bf25eeda80ec9fb15c53564dbaa32e5d2c7deff|
|[winsync-1.1.4.tar.bz2]({{ site.binaries_url }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto-windowssync.html)|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.7.tar.bz2)|console.git|389-console-1.1.7|[WindowsSync](../howto/howto-windowsconsole.html|87ae48c131b2964f9dac97e011a8a8fb61d3a8a4|
|[idm-console-framework-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.7.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.7|[buildingconsole.html](buildingconsole.html)|2081dea597c2fe0078a8a8f4047884cb1e02e470|
|[389-ds-console-1.2.6.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.6.tar.bz2)|ds-console.git|389-ds-console-1.2.6|[DirectoryConsole](buildingconsole.html#ds-console)|adc763187f6b2e7f9f347b930276ab5712eb7807|
|[389-admin-console-1.1.8.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.8.tar.bz2)|admin-console.git|389-admin-console-1.1.8|[AdminConsole](buildingconsole.html#admin-console)|8e093715b215e64ae9b307bc96df55d2bd496da8|

### 389 Directory Server 1.2.9

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.2.9

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.9.9.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.2.9.9.tar.bz2)|ds.git|389-ds-base-1.2.9.9|[Building](building.html)|d61a7284eafe5984a38e332445049d15679ed14e|
|[389-admin-1.1.23.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.23.tar.bz2)|admin.git|389-admin-1.1.23|[AdminServer](../administration/adminserver.html)|b3013f3ce833f5dae8ec33f881f46a064f4d1d3d|
|[389-adminutil-1.1.14.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.14.tar.bz2)|adminutil.git|389-adminutil-1.1.14|[AdminUtil](../administration/adminutil.html)|b6af0f12cdeda2d1188a6c6c1d7851da60ad4331|
|[389-dsgw-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/389-dsgw-1.1.7.tar.bz2)|dsgw.git|389-dsgw-1.1.7|[DSGW\_Building](../administration/dsgw-building.html)|0eb4e05d7ae763395a9338b0a76f441be51612e7|
|[winsync-1.1.4.tar.bz2]({{ site.binaries_url }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.7.tar.bz2)|console.git|389-console-1.1.7|[WindowsSync](../howto/howto-windowsconsole.html|87ae48c131b2964f9dac97e011a8a8fb61d3a8a4|
|[idm-console-framework-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.7.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.7|[buildingconsole.html](buildingconsole.html)|2081dea597c2fe0078a8a8f4047884cb1e02e470|
|[389-ds-console-1.2.6.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.6.tar.bz2)|ds-console.git|389-ds-console-1.2.6|[DirectoryConsole](buildingconsole.html#ds-console)|adc763187f6b2e7f9f347b930276ab5712eb7807|
|[389-admin-console-1.1.8.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.8.tar.bz2)|admin-console.git|389-admin-console-1.1.8|[AdminConsole](buildingconsole.html#admin-console)|8e093715b215e64ae9b307bc96df55d2bd496da8|

### 389 Directory Server 1.2.8

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.8.3.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.2.8.3.tar.bz2)|ds.git|389-ds-base-1.2.8.3|[Building](building.html)|87f1f8ec0044f4b1766b2b65b34f4e14d9d0d41d|
|[389-admin-1.1.16.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.16.tar.bz2)|admin.git|389-admin-1.1.16|[AdminServer](../administration/adminserver.html)|e2facc231d1475b218321b7dbdb04d8f9b6ebacb|
|[389-adminutil-1.1.13.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.13.tar.bz2)|adminutil.git|389-adminutil-1.1.13|[AdminUtil](../administration/adminutil.html)|1de90fc408b0046aeb346fad7e2251f10e07024a|
|[389-dsgw-1.1.6.tar.bz2]({{ site.binaries_url }}/binaries/389-dsgw-1.1.6.tar.bz2)|dsgw.git|389-dsgw-1.1.6|[DSGW\_Building](../administration/dsgw-building.html)|2e18c7b3ccb7c98b68917538c2a75eb445b734db|
|[winsync-1.1.4.tar.bz2]({{ site.binaries_url }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.6.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.6.tar.bz2)|console.git|389-console-1.1.6|[WindowsSync](../howto/howto-windowsconsole.html|06f7128bc86d1429c6fd0a920ecbb0bac9799206|
|[idm-console-framework-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.7.tar.bz2)|console(CVS)|FedoraConsoleFramework\_1\_1\_7(CVS)|[buildingconsole.html](buildingconsole.html)|f64814028eb4abc8d7fadac794d52f1b9d32de99|
|[389-ds-console-1.2.5.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.5.tar.bz2)|ds-console.git|389-ds-console-1.2.5|[DirectoryConsole](buildingconsole.html#ds-console)|d3eafbec8e7b71f05baa3a9e64ba31692ed6daf8|
|[389-admin-console-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.7.tar.bz2)|admin-console.git|389-admin-console-1.1.7|[AdminConsole](buildingconsole.html#admin-console)|917db7c8b6f4390cbe688966826ac499d6d6cd75|

### 389 Directory Server 1.2.7

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.7.5.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.2.7.5.tar.bz2)|ds.git|389-ds-base-1.2.7.5|[Building](building.html)|5277c8b26ab45c4399a836de4c4c0294b6b4de2b|
|[389-admin-1.1.14.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.14.tar.bz2)|admin.git|389-admin-1.1.14|[AdminServer](../administration/adminserver.html)|8379b955de459e0efcb1207f8da0881fcd6d9964|
|[389-adminutil-1.1.13.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.13.tar.bz2)|adminutil.git|389-adminutil-1.1.13|[AdminUtil](../administration/adminutil.html)|1de90fc408b0046aeb346fad7e2251f10e07024a|
|[389-dsgw-1.1.6.tar.bz2]({{ site.binaries_url }}/binaries/389-dsgw-1.1.6.tar.bz2)|dsgw.git|389-dsgw-1.1.6|[DSGW\_Building](../administration/dsgw-building.html)|2e18c7b3ccb7c98b68917538c2a75eb445b734db|
|[winsync-1.1.4.tar.bz2]({{ site.binaries_url }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.6.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.6.tar.bz2)|console.git|389-console-1.1.6|[WindowsSync](../howto/howto-windowsconsole.html|06f7128bc86d1429c6fd0a920ecbb0bac9799206|
|[idm-console-framework-1.1.5.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.5.tar.bz2)|console(CVS)|FedoraConsoleFramework\_1\_1\_5(CVS)|[buildingconsole.html](buildingconsole.html)|15f1d2af4cac986c6caad39f4ed02191169fcb42|
|[389-ds-console-1.2.3.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.3.tar.bz2)|ds-console.git|389-ds-console-1.2.3|[DirectoryConsole](buildingconsole.html#ds-console)|9d433a142a92c7b6a2cc46927dba4140da05810b|
|[389-admin-console-1.1.5.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.5.tar.bz2)|admin-console.git|389-admin-console-1.1.5|[AdminConsole](buildingconsole.html#admin-console)|3baf33f3a045fafb6cd7157e448c9b8453f86721|

### 389 Directory Server 1.2.6.1

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.6.1.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.2.6.1.tar.bz2)|ds.git|389-ds-base-1.2.6.1|[Building](building.html)|06e84397f93be1fd39bff4eeba981c67d456c6a4|
|[389-admin-1.1.11.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.11.tar.bz2)|admin.git|389-admin-1.1.11|[AdminServer](../administration/adminserver.html)|31e6ae835161f670a6393f36b269a7ad1fa4e667|
|[389-adminutil-1.1.10.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.10.tar.bz2)|adminutil.git|389-adminutil-1.1.10|[AdminUtil](../administration/adminutil.html)|310be539a4cd31a892858cabf609c0d3acedad92|
|[winsync-1.1.4.tar.bz2]({{ site.binaries_url }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.6.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.6.tar.bz2)|console.git|389-console-1.1.6|[WindowsSync](../howto/howto-windowsconsole.html|06f7128bc86d1429c6fd0a920ecbb0bac9799206|
|[idm-console-framework-1.1.5.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.5.tar.bz2)|console(CVS)|FedoraConsoleFramework\_1\_1\_5(CVS)|[buildingconsole.html](buildingconsole.html)|15f1d2af4cac986c6caad39f4ed02191169fcb42|
|[389-ds-console-1.2.3.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.3.tar.bz2)|ds-console.git|389-ds-console-1.2.3|[DirectoryConsole](buildingconsole.html#ds-console)|9d433a142a92c7b6a2cc46927dba4140da05810b|
|[389-admin-console-1.1.5.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.5.tar.bz2)|admin-console.git|389-admin-console-1.1.5|[AdminConsole](buildingconsole.html#admin-console)|3baf33f3a045fafb6cd7157e448c9b8453f86721|

### 389 Directory Server 1.2.5

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.5.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.2.5.tar.bz2)|ds.git|389-ds-base-1.2.5|[Building](building.html)|40340cdf1d1816c5a6b97acfb770c1f5ad6f7f4a|
|[389-admin-1.1.10.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.10.tar.bz2)|admin.git|389-admin-1.1.10|[AdminServer](../administration/adminserver.html)|a1e4f053c6915a500d411306614a6b58c941f93c|
|[389-adminutil-1.1.9.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.9.tar.bz2)|adminutil.git|389-adminutil-1.1.9|[AdminUtil](../administration/adminutil.html)|516cd69f7a0b34f52563a4a5b8e4a6f9b0839177|
|[389-dsgw-1.1.5.tar.bz2]({{ site.binaries_url }}/binaries/389-dsgw-1.1.5.tar.bz2)|dsgw.git|389-dsgw-1.1.5|[DSGW\_Building](../administration/dsgw-building.html)|9ef4a18ddd09a566402f1fd68bef8f774857d680|

### 389 Directory Server 1.2.4

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.4.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.2.4.tar.bz2)|ds.git|389-ds-base-1.2.4|[Building](building.html)|54a9257a3b979c5c953e69a45739912f919ebdda|
|[winsync-1.1.3.tar.bz2]({{ site.binaries_url }}/binaries/winsync-1.1.3.tar.bz2)|winsync.git|winsync-1.1.3|[WindowsSync](../howto/howto-windowssync.html|d4b7ee3e75e8fec26bd0a3ebf0f4389d14376529|
|[389-console-1.1.4.a1.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.4.a1.tar.bz2)|console.git|389-console-1.1.4.a1|[WindowsSync](../howto/howto-windowsconsole.html|8fc8616889ef8ef9145fb0198ee02dd5b4b0bcd6|

### 389 Directory Server 1.2.3

Modules are git modules and tags are git tags, except where noted as CVS.

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-adminutil-1.1.8.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.8.tar.bz2)|adminutil.git|389-adminutil-1.1.8|[AdminUtil](../administration/adminutil.html)|ff2090c74f63cce65f8222263207ee5442a9e325|
|[389-ds-base-1.2.3.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.2.3.tar.bz2)|ds.git|389-ds-base-1.2.3|[Building](building.html)|f1ed676a3fa2d118c4b57926502bcba9bcd413ef|
|[389-admin-1.1.9.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.9.tar.bz2)|admin.git,mod\_admserv(CVS),mod\_restartd(CVS)|389-admin-1.1.9,three89Admin\_1\_1\_9(CVS)|[AdminServer](../administration/adminserver.html)|523d0c8b9c88c5c1c1312cc0e89ac15cd07a598c|
|[389-console-1.1.3.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.3.tar.bz2)|console.git|389-console-1.1.3|[389 Console](buildingconsole.html#framework)|b1a5afa6e7039283ac340939d5e1728431370ba9|
|[idm-console-framework-1.1.3.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.3.tar.bz2)|console(CVS)|FedoraConsoleFramework\_1\_1\_3(CVS)|[buildingconsole.html](buildingconsole.html)|b234a0549e80b739672323e963ae149a5be188df|
|[389-ds-console-1.2.0.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.0.tar.bz2)|ds-console.git|389-ds-console-1.2.0|[DirectoryConsole](buildingconsole.html#ds-console)|403c493f69b94747ea9078799a1f871b71a71d73|
|[389-admin-console-1.1.4.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.4.tar.bz2)|admin-console.git|389-admin-console-1.1.4|[AdmservConsole](buildingconsole.html#admin-console)|29a4ba674b4f532c67ed1303162e5b232bcf9821|
|[389-dsgw-1.1.4.tar.bz2]({{ site.binaries_url }}/binaries/389-dsgw-1.1.4.tar.bz2)|dsgw.git|389-dsgw-1.1.4|[DSGW\_Building](../administration/dsgw-building.html)|52e01146f9b35b46c5deb288806b10624ffff855|
|[winsync-1.1.2.tar.bz2]({{ site.binaries_url }}/binaries/winsync-1.1.2.tar.bz2)|winsync.git|winsync-1.1.2|[WindowsSync](../howto/howto-windowssync.html|7391f4bde7ef8a42bc2722e3f581abe3ac09b639|

### 389 Directory Server 1.2.2

Modules are git modules and tags are git tags, except where noted as CVS.

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-adminutil-1.1.8.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.8.tar.bz2)|adminutil.git|389-adminutil-1.1.8|[AdminUtil](../administration/adminutil.html)|ff2090c74f63cce65f8222263207ee5442a9e325|
|[389-ds-base-1.2.2.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-base-1.2.2.tar.bz2)|ds.git|389-ds-base-1.2.2|[Building](building.html)|459aa7228b7ef775db5ba588a6b795db997da4f4|
|[389-admin-1.1.8.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.8.tar.bz2)|admin.git,mod\_admserv(CVS),mod\_restartd(CVS)|389-admin-1.1.8,three89Admin\_1\_1\_8(CVS)|[AdminServer](../administration/adminserver.html)|4d1eb839581b21053f24f9f0908f20fe60a51c37|
|[389-console-1.1.3.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.3.tar.bz2)|console.git|389-console-1.1.3|[389 Console](buildingconsole.html#framework)|b1a5afa6e7039283ac340939d5e1728431370ba9|
|[idm-console-framework-1.1.3.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.3.tar.bz2)|console(CVS)|FedoraConsoleFramework\_1\_1\_3(CVS)|[buildingconsole.html](buildingconsole.html)|b234a0549e80b739672323e963ae149a5be188df|
|[389-ds-console-1.2.0.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.0.tar.bz2)|ds-console.git|389-ds-console-1.2.0|[DirectoryConsole](buildingconsole.html#ds-console)|403c493f69b94747ea9078799a1f871b71a71d73|
|[389-admin-console-1.1.4.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.4.tar.bz2)|admin-console.git|389-admin-console-1.1.4|[AdmservConsole](buildingconsole.html#admin-console)|29a4ba674b4f532c67ed1303162e5b232bcf9821|
|[389-dsgw-1.1.4.tar.bz2]({{ site.binaries_url }}/binaries/389-dsgw-1.1.4.tar.bz2)|dsgw.git|389-dsgw-1.1.4|[DSGW\_Building](../administration/dsgw-building.html)|52e01146f9b35b46c5deb288806b10624ffff855|
|[winsync-1.1.0.tar.bz2]({{ site.binaries_url }}/binaries/winsync-1.1.0.tar.bz2)|winsync.git|winsync\_1\_1\_0|[WindowsSync](../howto/howto-windowssync.html|bb661761138c0f67fe1e33ea870c826e2fdb78b8|

### 389 Admin Server and Console packges 1.1.46

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-admin.1.1.46.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.46.tar.bz2)|admin.git|389-admin-1.1.46|[Admin](../administration/adminserver.html)|735c51c0f19e448fbe9f552893ee4f9297420831|
|[389-adminutil.1.1.23.tar.bz2]({{ site.binaries_url }}/binaries/389-adminutil-1.1.23.tar.bz2)|adminutil.git|389-adminutil-1.1.23|[Adminutil](../administration/adminutil.html)|daf72628b97337ad2b48e8753f2bc7b01a4482c0|
|[389-console.1.1.19.tar.bz2](https://releases.pagure.org/389-console/389-console-1.1.18.tar.bz2)|389-console.git|389-console-1.1.19|[Building Console](buildingconsole.html)|8713628b1d0042acd59ff09ec487d4dccf1b3e8acf6008e7d1499e7954835744d601039ee2b6232a9d5f4022a1d56e7258fd1745dd75279b459050262599b466|
|[389-console.1.1.18.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.18.tar.bz2)|console.git|389-admin-1.1.45|[Building Console](buildingconsole.html)|ad6929bc9391d7b725aa8246fce5cc22225829b3|
|[389-admin-console.1.1.12.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.12.tar.bz2)|admin-console.git|389-admin-console-1.1.12|[Building Console](buildingconsole.html)|ecfce08e40760f9b8ed4e3b0aa90d7e026d761f9|
|[389-ds-console-1.2.16.tar.bz2]({{ site.binaries_url }}/binaries/389-ds-console-1.2.16.tar.bz2)|ds-console.git|389-ds-console-1.2.16|[Building Console](buildingconsole.html)|1c7977a6720e77ccc26440c54672b729f9a8820d|
|[idm-console-framework-1.1.17.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.17.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.17|[Building Console](buildingconsole.html)|abaa10be90f51ed61e4d16348eee7706fda19df1|

### EPEL6 packages

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-admin.1.1.43.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-1.1.43.tar.bz2)|admin.git|389-admin-1.1.43|[Admin](../administration/adminserver.html)|3d931830ce832b7e0f820689ca30e5996b873f75|
|[389-console-1.1.17.tar.bz2]({{ site.binaries_url }}/binaries/389-console-1.1.17.tar.bz2)|console.git|389-console-1.1.17|[Building Console](buildingconsole.html)|b63c5c53936752e55ba205ba827af7cc96658cbb|
|[389-admin-console-1.1.11.tar.bz2]({{ site.binaries_url }}/binaries/389-admin-console-1.1.11.tar.bz2)|admin-console.git|389-admin-console-1.1.11|[Building Console](buildingconsole.html)|852a1c121923137b9048b7e498b7f03965cc0d3b|
|[idm-console-framework-1.1.15.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.15.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.15|[Building Console](buildingconsole.html)|86ca70b34bba1ceffb206cd945a5d077544a83f7|

### Fedora Directory Server 1.2.0

|Source tarball|CVS module|CVS static tag|More Info|SHA1SUM|
|--------------|----------|--------------|---------|-------|
|[adminutil-1.1.8.tar.bz2]({{ site.binaries_url }}/binaries/adminutil-1.1.8.tar.bz2)|adminutil|adminutil\_1\_1\_8|[AdminUtil](../administration/adminutil.html)|8deb2b018f96270ecb41f3625cdf7069357b25e9|
|[fedora-ds-base-1.2.0.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-base-1.2.0.tar.bz2)|ldapserver|FedoraDirSvr\_1\_2\_0|[Building](building.html)|bbce7a98ebbdc13e4ca11c57cb5990a5d4b1bb87|
|[fedora-ds-admin-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-admin-1.1.7.tar.bz2)|adminserver,mod\_admserv,mod\_restartd|FedoraDirSrvAdmin\_1\_1\_7|[AdminServer](../administration/adminserver.html)|2018efb83de6ab3af1ff386197d621f07f67b66f|
|[fedora-idm-console-1.1.3.tar.bz2]({{ site.binaries_url }}/binaries/fedora-idm-console-1.1.3.tar.bz2)|fedora-idm-console|FedoraIDMConsole\_1\_1\_3|[Fedora IDM Console](buildingconsole.html#framework)|bc9fd58b7f9266eab3cca025a9030e2c76a67829|
|[idm-console-framework-1.1.3.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.3.tar.bz2)|console|FedoraConsoleFramework\_1\_1\_3|[buildingconsole.html](buildingconsole.html)|b234a0549e80b739672323e963ae149a5be188df|
|[fedora-ds-console-1.2.0.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-console-1.2.0.tar.bz2)|directoryconsole|FedoraDirectoryconsole\_1\_2\_0|[DirectoryConsole](buildingconsole.html#ds-console)|81a6a3647b46d7562bc1dab9e390969aa34ceb8d|
|[fedora-ds-admin-console-1.1.3.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-admin-console-1.1.3.tar.bz2)|admservconsole|FedoraAdmservconsole\_1\_1\_3|[AdmservConsole](buildingconsole.html#admin-console)|6ddebd0771a1ad30721e5c93d926a35e7909618c|
|[fedora-ds-dsgw-1.1.2.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-dsgw-1.1.2.tar.bz2)|dsgw|FedoraDirSvrDSGW\_1\_1\_2|[DSGW\_Building](../administration/dsgw-building.html)|f0e86c79da993fa8d01c7f3d90eef9c39d69c8d8|
|[winsync-1.1.0.tar.bz2]({{ site.binaries_url }}/binaries/winsync-1.1.0.tar.bz2)|winsync|winsync\_1\_1\_0|[WindowsSync](../howto/howto-windowssync.html|bb661761138c0f67fe1e33ea870c826e2fdb78b8|

### Fedora Directory Server 1.1.3

This includes only the fedora-ds-base package. All of the other packages are the same as for 1.1.2

|Source tarball|CVS module|CVS static tag|More Info|MD5SUM|
|--------------|----------|--------------|---------|------|
|[fedora-ds-base-1.1.3.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-base-1.1.3.tar.bz2)|ldapserver|FedoraDirSvr\_1\_1\_3|[Building](building.html)|65aeecb66a6977f7f4706569d02ad8ce|

### Fedora Directory Server 1.1.2

|Source tarball|CVS module|CVS static tag|More Info|MD5SUM|
|--------------|----------|--------------|---------|------|
|[adminutil-1.1.7.tar.bz2]({{ site.binaries_url }}/binaries/adminutil-1.1.7.tar.bz2)|adminutil|adminutil\_1\_1\_7|[AdminUtil](../administration/adminutil.html)|e7d03be4651b36d1213b4f5cc15dfc5c|
|[fedora-ds-base-1.1.2.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-base-1.1.2.tar.bz2)|ldapserver|FedoraDirSvr\_1\_1\_2|[Building](building.html)|797c93351e8fcca9bac6326e7270355e|
|[fedora-ds-admin-1.1.6.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-admin-1.1.6.tar.bz2)|adminserver,mod\_admserv,mod\_restartd|FedoraDirSrvAdmin\_1\_1\_6|[AdminServer](../administration/adminserver.html)|63a2b5f4496d0cb4b067160fc9da5fd8|
|[idm-console-framework-1.1.2.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.2.tar.bz2)|console|FedoraConsoleFramework\_1\_1\_2|[buildingconsole.html](buildingconsole.html)|f2db919004fcaf5d6adf6db55b4d589f|
|[fedora-ds-console-1.1.2.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-console-1.1.2.tar.bz2)|directoryconsole|FedoraDirectoryconsole\_1\_1\_2|[DirectoryConsole](buildingconsole.html#ds-console)|62964d896042c032143d9bac60abd105|
|[fedora-ds-admin-console-1.1.2.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-admin-console-1.1.2.tar.bz2)|admservconsole|FedoraAdmservconsole\_1\_1\_2|[AdmservConsole](buildingconsole.html#admin-console)|e40ffc75263637e886fdf62b20e9a628|
|[fedora-ds-dsgw-1.1.1.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-dsgw-1.1.1.tar.bz2)|dsgw|FedoraDirSvrDSGW\_1\_1\_1|[DSGW\_Building](../administration/dsgw-building.html)|fd86e38de705e75296100d7fe9025970|

### Fedora Directory Server 1.1.1

|Source tarball|CVS module|CVS static tag|More Info|MD5SUM|
|--------------|----------|--------------|---------|------|
|[fedora-ds-base-1.1.1.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-base-1.1.1.tar.bz2)|ldapserver|FedoraDirSvr111|[Building](building.html)|c525e0412ae4b9582adbd01305126975|
|[idm-console-framework-1.1.1.tar.bz2]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.1.tar.bz2)|console|FedoraConsoleFramework112|[buildingconsole.html](buildingconsole.html)|a23291c9aea256f075b69df981fae42a|
|[fedora-idm-console-1.1.1.tar.bz2]({{ site.binaries_url }}/binaries/fedora-idm-console-1.1.1.tar.bz2)|fedora-idm-console|FedoraIDMConsole112|[IDMConsole](buildingconsole.html#framework)|4c2b16080a3c6e477924091c02d721bf|
|[fedora-ds-console-1.1.1.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-console-1.1.1.tar.bz2)|directoryconsole|FedoraDirectoryconsole112|[DirectoryConsole](buildingconsole.html#ds-console)|ee0401937a81ce2466292a4f9b14e20a|
|[fedora-admin-console-1.1.1.tar.bz2]({{ site.binaries_url }}/binaries/fedora-admin-console-1.1.1.tar.bz2)|admservconsole|FedoraAdmservconsole112|[AdmservConsole](buildingconsole.html#admin-console)|e0f16a5a426a2c2bceefb5cfb99ea9c7|
|[fedora-ds-admin-1.1.5.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-admin-1.1.5.tar.bz2)|adminserver,mod\_admserv,mod\_restartd|FedoraDirSrvAdmin115|[AdminServer](../administration/adminserver.html)|766c2ab5a7659450ac9fb37fac5ddeb5|
|[adminutil-1.1.6.tar.bz2]({{ site.binaries_url }}/binaries/adminutil-1.1.6.tar.bz2)|adminutil|FedoraAdminutil116|[AdminUtil](../administration/adminutil.html)|b01d441f81d3d260ba84e4f0d5311721|
|[mod\_nss-1.0.7.tar.gz]({{ site.binaries_url }}/binaries/mod_nss-1.0.7.tar.gz)|mod\_nss|mod\_nss107|[mod\_nss](../administration/mod-nss.html)|71107cbc702bf07c6c79843aa92a0e09|

### Fedora Directory Server 1.1.0

These are the sources which were used to build the initial 1.1.0 release.

|Source tarball|CVS module|CVS static tag|More Info|MD5SUM|
|--------------|----------|--------------|---------|------|
|[idm-common-framework-1.1.0.tar.bz2]({{ site.binaries_url }}/binaries/idm-common-framework-1.1.0.tar.bz2)|console|FedoraConsoleFramework111|[buildingconsole.html](buildingconsole.html)|a24d54361b12984b07fc01ff8f8af447|
|[fedora-idm-console-1.1.0.tar.bz2]({{ site.binaries_url }}/binaries/fedora-idm-console-1.1.0.tar.bz2)|fedora-idm-console|FedoraIDMConsole111|[IDMConsole](buildingconsole.html#framework)|e76a8212c6eaaaab3333aa076ca5499d|
|[fedora-ds-console-1.1.0.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-console-1.1.0.tar.bz2)|directoryconsole|FedoraDirectoryconsole111|[DirectoryConsole](buildingconsole.html#ds-console)|7b69248b8f18484f03e260a144b1265c|
|[fedora-admin-console-1.1.0.tar.bz2]({{ site.binaries_url }}/binaries/fedora-admin-console-1.1.0.tar.bz2)|admservconsole|FedoraAdmservconsole111|[AdmservConsole](buildingconsole.html#admin-console)|32ecb58f33660705edcd8c3606de750d|
|[fedora-ds-base-1.1.0.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-base-1.1.0.tar.bz2)|ldapserver|FedoraDirSvr110|[Building](building.html)|a60d1ce51207e61c48b70aa85ae5e5a5|
|[fedora-ds-admin-1.1.1.tar.bz2]({{ site.binaries_url }}/binaries/fedora-ds-admin-1.1.1.tar.bz2)|adminserver,mod\_admserv,mod\_restartd|FedoraDirSrvAdmin112|[AdminServer](../administration/adminserver.html)|f50f2b6c983851c5e912047807bbcca6|
|[adminutil-1.1.5.tar.bz2]({{ site.binaries_url }}/binaries/adminutil-1.1.5.tar.bz2)|adminutil|FedoraAdminutil115|[AdminUtil](../administration/adminutil.html)|1ce95159db07040d7095b805e9b3b533|
|[mod\_nss-1.0.7.tar.gz]({{ site.binaries_url }}/binaries/mod_nss-1.0.7.tar.gz)|mod\_nss|mod\_nss107|[mod\_nss](../administration/mod-nss.html)|71107cbc702bf07c6c79843aa92a0e09|

### 389 Directory Password Synchronization 1.1.6

This is the source which were used to build the 389 Directory Password Synchronization.

|Source tarball|git module|git tag|MD5SUM|
|--------------|----------|-------|------|
|[389-passsync-1.1.6.tar.bz2]({{ site.binaries_url }}/binaries/389-passsync-1.1.6.tar.bz2)|winsync|winsync-1.1.6|13493549a90182e064ce7987f869c56f64e48ac0|
