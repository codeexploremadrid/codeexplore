scp -i privatekey DIPCAgent-18.4.3_Linux-x64.zip opc@130.61.100.52:DIPCAgent-18.4.3_Linux-x64.zip
ssh -i privatekey opc@130.61.100.52 'unzip DIPCAgent-18.4.3_Linux-x64.zip'
ssh -i privatekey opc@130.61.100.52 'dicloud/dicloudConfigureAgent.sh -recreate -debug -user=guillermo.best@oracle.com -password=Oracle##123456 -dipcport=8001 -dipchost=dipcdocker-dipcocicentral-efumhf91.srv.ravcloud.com -authType=PASSWORD >/dev/null 2>&1 &'
ssh -i privatekey opc@130.61.100.52 'nohup dicloud/startAgentInstance.sh & > nm.out'
