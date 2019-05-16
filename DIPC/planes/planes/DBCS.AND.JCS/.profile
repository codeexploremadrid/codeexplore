# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

ORACLE_HOME=/media/Data/u02/product/11.2.0/client_1
export ORACLE_HOME
TNS_ADMIN=/media/Data/u02/tns
export TNS_ADMIN
ORACLE_BASE=/media/Data/u02
export ORACLE_BASE
PATH=$ORACLE_HOME/bin:$PATH
export PATH
FKST=/u03/Forecasting/4Kst_v1.3
export FKST
AWRTK=/media/Data/Documentation/Oracle/AWR.Toolkit
export AWRTK
## LD_LIBRARY_PATH=/media/Data/u02/product/11.2.0/client_1/lib
## export LD_LIBRARY_PATH


#### VARIABLES DE ENTORNO PARA TERRAFORM ENTORNO 25 ######
##export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaadfcbr7fw2atbmpigwucbodxrnnshjy57jhvx45gvrqt7cz7mu2zq
##export TF_VAR_user_ocid=ocid1.user.oc1..aaaaaaaa2ucvogo2t5qfxblc4jae5gvojle36o6whpuz3su53efih67lzy3q
##export TF_VAR_compartment_ocid=ocid1.compartment.oc1..aaaaaaaazctlgulczctyjgb2tz4wqtcbozxibsbytzvoqlfai45stazibzgq
##export TF_VAR_fingerprint=f4:96:00:67:f9:82:0f:79:eb:0c:17:43:68:93:09:a2
##export TF_VAR_private_key_path=/media/Data/home/stef/.oci/oci_api_key.pem
##export TF_VAR_region=us-phoenix-1
###############################################


#### VARIABLES DE ENTORNO PARA TERRAFORM ENTORNO JONATHAN PRICE ######
##export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaanpwxhl5magaazbfborl2q7xdbt2jeraj37c3t23jvc4pbpdwmrrq
##export TF_VAR_tenancy=oraclejonathanp
##export TF_VAR_user_ocid=ocid1.user.oc1..aaaaaaaaxh534dfwg6ydlwexn4nixnooao7pmfzqvtwi5ihpv7dij7ub7cfq
##export TF_VAR_compartment_ocid=ocid1.compartment.oc1..aaaaaaaa2xm2m4fpji3qd2cvcf62alfzp5bk7iyhmjgx7bfczpcezfedcnvq
##export TF_VAR_fingerprint=f4:96:00:67:f9:82:0f:79:eb:0c:17:43:68:93:09:a2
##export TF_VAR_private_key_path=/media/Data/home/stef/.oci/oci_api_key.pem
##export TF_VAR_region=us-phoenix-1
###############################################


#### VARIABLES DE ENTORNO PARA TERRAFORM ENTORNO TCLOUD2 ######
export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaadij4t4b32vewx4bklsmx4l54tmwja5d2j2yatfh2t3j2x6fdo7eq
export TF_VAR_tenancy=telefonicacloud2
export TF_VAR_identity_domain="idcs-e6f40c2d9ed6483dbabcf6ff50cd69ee"
export TF_VAR_api_user=api.user
export TF_VAR_api_user_pwd="AaZZ0r_cle#1"
export TF_VAR_admin_user=cloud.admin
export TF_VAR_admin_user_pwd="AaZZ0r_cle#1"
export TF_VAR_user_ocid=ocid1.user.oc1..aaaaaaaawvyzhovzcie742dkz7guxvmyuzcxkl4t7khigxdnduhgnv6ab7za
export TF_VAR_compartment_ocid=ocid1.compartment.oc1..aaaaaaaa7th7e3la75hrzkakyoosprvibmfme57v42rrbazd2emhl2rlfnma
export TF_VAR_fingerprint=19:cb:8a:41:50:e9:90:3d:10:70:47:59:9c:18:9e:91
export TF_VAR_private_key_path=/media/Data/home/stef/.oci/oci_api_key.pem
export TF_VAR_region=eu-frankfurt-1
export TF_VAR_object_storage_user=api.user
export TF_VAR_swift_password="1(;DS+4cJ3pmCA0Ps2dP"
##
##export DEBUG=true
##export TF_LOG=DEBUG
##export TF_LOG_PATH=/media/Data/Preventa/Everis/20190828.Terraform/trace/debug.log
##export OCI_GO_SDK_DEBUG=1
###############################################

#### VARIABLES DE ENTORNO PARA TERRAFORM ENTORNO gse00014953 ######
##export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaa44y4ow5lhuc6aw2iv3almg2lrfgrvwatjq3jdedn7unwdmjxkkqq
##export TF_VAR_tenancy=gse00014953
##export TF_VAR_identity_domain="idcs-df0f80fd27914a8bb415e04f281584cb"
##export TF_VAR_api_user=api.user
##export TF_VAR_api_user_pwd="pAstEl@4OdDItY"
##export TF_VAR_admin_user=cloud.admin
##export TF_VAR_admin_user_pwd="pAstEl@4OdDItY"
##export TF_VAR_user_ocid=ocid1.user.oc1..aaaaaaaavzigwxmi2aow2lw4rsbt4dhsfprfcszpbkcusobcj2mbkvtmn2vq
##export TF_VAR_compartment_ocid=ocid1.compartment.oc1..aaaaaaaaz7w4igzn2inh4zkuozbrmggwrp2m7s6makav3hh2wmyd2hzmwemq
##export TF_VAR_fingerprint=19:cb:8a:41:50:e9:90:3d:10:70:47:59:9c:18:9e:91
##export TF_VAR_private_key_path=/media/Data/home/stef/.oci/oci_api_key.pem
##export TF_VAR_region=us-ashburn-1
##export TF_VAR_object_storage_user=api.user
##export TF_VAR_swift_password="Y<a+#g6;jXD4zMh]5YG1"
###############################################

#### VARIABLES DE ENTORNO PARA TERRAFORM ENTORNO gse00015008 ######
##export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaazewdgktwvv64r3oe7d2e5nvc7kp74fanf4vzm6a6efufmeknizjq
##export TF_VAR_tenancy=gse00015008
##export TF_VAR_identity_domain="idcs-a8ba8baa902141d6a08b4c8db5d4f2ce"
##export TF_VAR_api_user=api.user
##export TF_VAR_api_user_pwd="undoNe@8LabOuR"
##export TF_VAR_admin_user=roland.dubois
##export TF_VAR_admin_user_pwd="undoNe@8LabOuR"
##export TF_VAR_user_ocid=ocid1.user.oc1..aaaaaaaac26dfdumrip4ci3ak4vpczzrih4o7u7g2by2hygnvttlzeplsnpq
##export TF_VAR_compartment_ocid=ocid1.compartment.oc1..aaaaaaaaqxlybxw2drh6pye4mpfui36hqtasizmbqzzjegcdf2nl6me5v42q
##export TF_VAR_fingerprint=19:cb:8a:41:50:e9:90:3d:10:70:47:59:9c:18:9e:91
##export TF_VAR_private_key_path=/media/Data/home/stef/.oci/oci_api_key.pem
##export TF_VAR_region=us-ashburn-1
##export TF_VAR_object_storage_user=api.user
##export TF_VAR_swift_password="xTLcF.DZr8pMv3_8ziu5"
###############################################


#### VARIABLES DE ENTORNO PARA TERRAFORM ENTORNO gse00014337 ######
##export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaa776lqgo27z33s4gem3kcz73kfqmjgbw3ozkcxhbn5ykh6o5tl4lq
##export TF_VAR_tenancy=gse00014337
##export TF_VAR_identity_domain="idcs-42a741245c5948ad865316ba336838bd"
##export TF_VAR_api_user=api.user
##export TF_VAR_api_user_pwd="moDern@4LeakEY"
##export TF_VAR_admin_user=cloud.admin
##export TF_VAR_admin_user_pwd="ImpIoUS@9Marsh"
##export TF_VAR_user_ocid=ocid1.user.oc1..aaaaaaaaofwzujqnppe5k5tujgk7cuwez42mw3kwhhgss643qw5fzemepyha
##export TF_VAR_compartment_ocid=ocid1.compartment.oc1..aaaaaaaass5p2ecyppx2eh2j5zpye7tvnuvmsf5n2bwkjxcvz7qz57hlr3za
##export TF_VAR_fingerprint=19:cb:8a:41:50:e9:90:3d:10:70:47:59:9c:18:9e:91
##export TF_VAR_private_key_path=/media/Data/home/stef/.oci/oci_api_key.pem
##export TF_VAR_region=us-ashburn-1
##export TF_VAR_object_storage_user=api.user
##export TF_VAR_swift_password="10{0{fY4xm3OJUNn6L0["
###############################################


