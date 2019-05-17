contents:
  source: data:,%23!%2Fusr%2Fbin%2Fenv%20bash%0A%0A%23%20example%0A%23%20export%20SETUP_ETCD_ENVIRONMENT%3D%24(oc%20adm%20release%20info%20--image-for%20setup-etcd-environment%20--registry-config%3D.%2Fconfig.json)%0A%23%20export%20KUBE_CLIENT_AGENT%3D%24(oc%20adm%20release%20info%20--image-for%20kube-client-agent%20--registry-config%3D.%2Fconfig.json)%0A%23%20sudo%20-E%20.%2Fetcd-member-recover.sh%20192.168.1.100%0A%0Aif%20%5B%5B%20%24EUID%20-ne%200%20%5D%5D%3B%20then%0A%20%20echo%20%22This%20script%20must%20be%20run%20as%20root%22%0A%20%20exit%201%0Afi%0A%0A%3A%20%24%7BSETUP_ETCD_ENVIRONMENT%3A%3F%22Need%20to%20set%20SETUP_ETCD_ENVIRONMENT%22%7D%0A%3A%20%24%7BKUBE_CLIENT_AGENT%3A%3F%22Need%20to%20set%20KUBE_CLIENT_AGENT%22%7D%0A%0Ausage%20()%20%7B%0A%20%20%20%20echo%20'Recovery%20server%20IP%20address%20required%3A%20.%2Fetcd-member-recover.sh%20192.168.1.100'%0A%20%20%20%20exit%0A%7D%0A%0Aif%20%5B%20%22%241%22%20%3D%3D%20%22%22%20%5D%3B%20then%0A%20%20%20%20usage%0Afi%0A%0ARECOVERY_SERVER_IP%3D%241%0A%0AASSET_DIR%3D.%2Fassets%0AASSET_DIR_TMP%3D%22%24ASSET_DIR%2Ftmp%22%0ACONFIG_FILE_DIR%3D%2Fetc%2Fkubernetes%0AMANIFEST_DIR%3D%22%24%7BCONFIG_FILE_DIR%7D%2Fmanifests%22%0AMANIFEST_STOPPED_DIR%3D%2Fetc%2Fkubernetes%2Fmanifests-stopped%0A%0AETCD_MANIFEST%3D%22%24%7BMANIFEST_DIR%7D%2Fetcd-member.yaml%22%0AETCD_CONFIG%3D%2Fetc%2Fetcd%2Fetcd.conf%0AETCDCTL%3D%24ASSET_DIR%2Fbin%2Fetcdctl%0AETCD_VERSION%3Dv3.3.10%0AETCD_DATA_DIR%3D%2Fvar%2Flib%2Fetcd%0AETCD_STATIC_RESOURCES%3D%22%24%7BCONFIG_FILE_DIR%7D%2Fstatic-pod-resources%2Fetcd-member%22%0A%0ASHARED%3D%2Fusr%2Flocal%2Fshare%2Fopenshift-recovery%0ATEMPLATE%3D%22%24SHARED%2Ftemplate%2Fetcd-generate-certs.yaml.template%22%0A%0Asource%20%22%2Fusr%2Flocal%2Fbin%2Fopenshift-recovery-tools%22%0A%0Afunction%20run%20%7B%0A%20%20init%0A%20%20dl_etcdctl%0A%20%20backup_manifest%0A%20%20backup_etcd_conf%0A%20%20backup_etcd_client_certs%0A%20%20stop_etcd%0A%20%20backup_data_dir%0A%20%20backup_certs%0A%20%20remove_certs%0A%20%20gen_config%0A%20%20download_cert_recover_template%0A%20%20DISCOVERY_DOMAIN%3D%24(grep%20-oP%20'(%3F%3C%3Ddiscovery-srv%3D).*%5B%5E%22%5D'%20%24ASSET_DIR%2Fbackup%2Fetcd-member.yaml%20)%0A%20%20if%20%5B%20-z%20%22%24DISCOVERY_DOMAIN%22%20%5D%3B%20then%0A%20%20%20%20echo%20%22Discovery%20domain%20can%20not%20be%20extracted%20from%20%24ASSET_DIR%2Fbackup%2Fetcd-member.yaml%22%0A%20%20%20%20exit%201%0A%20%20fi%0A%20%20CLUSTER_NAME%3D%24(echo%20%24%7BDISCOVERY_DOMAIN%7D%20%7C%20grep%20-oP%20'%5E.*%3F(%3F%3D%5C.)')%0A%20%20populate_template%20'__ETCD_DISCOVERY_DOMAIN__'%20%22%24DISCOVERY_DOMAIN%22%20%22%24TEMPLATE%22%20%22%24ASSET_DIR%2Ftmp%2Fetcd-generate-certs.stage1%22%0A%20%20populate_template%20'__SETUP_ETCD_ENVIRONMENT__'%20%22%24SETUP_ETCD_ENVIRONMENT%22%20%22%24ASSET_DIR%2Ftmp%2Fetcd-generate-certs.stage1%22%20%22%24ASSET_DIR%2Ftmp%2Fetcd-generate-certs.stage2%22%0A%20%20populate_template%20'__KUBE_CLIENT_AGENT__'%20%22%24KUBE_CLIENT_AGENT%22%20%22%24ASSET_DIR%2Ftmp%2Fetcd-generate-certs.stage2%22%20%22%24MANIFEST_STOPPED_DIR%2Fetcd-generate-certs.yaml%22%0A%20%20start_cert_recover%0A%20%20verify_certs%0A%20%20stop_cert_recover%0A%20%20patch_manifest%0A%20%20etcd_member_add%0A%20%20start_etcd%0A%7D%0A%0Arun%0A
  verification: {}
filesystem: root
mode: 493
path: /usr/local/bin/etcd-member-recover.sh
