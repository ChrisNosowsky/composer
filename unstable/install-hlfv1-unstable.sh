ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� J�lY �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�l4�r1.���X�� �ڿ\ۑ- �8��W����F�-[5�]��mS����@{�� �y��E��tGVuh��r�sI�ړ�(�34���fZ�Q~���iX��U	@l�0;�.��6I�z_��ug��*K�|�*3��.��� ��� t�dWsR��C�A�:����Az��%7,U��P�Qm��JN�<<7���d+�j�&0��� �)�l��-� D��>;�݅ú�U�"X��у����c�X��FR�5{Nj��*�2�L�a5���e���3#AJ����i[�������B��4����g�^M�|��E��h�H�����fp{��Kc̒�f��YE�3���w�D�+r�@5L������9e��{5C�	We��B۩����u0s�eR�#�X���sFݔ{5)q�\I�ub��1*�������Zy�A~��f���_:t��%Z�W"���tYi�I�w��R�Z���5a?��?b�ȃ���x\�i��0^��C�?��'@xpJ����ϙ�V����;�m�̿p����矍�x!.�������[<�.�P�HC�;�m����P��OS���C�?&���Y�T+��ẇ+�����s�D�"g�!��1�oZ~y0G����������6�����s�ߔ�.�·�mC�6�������"�@�?�C* ��>�Y��x�5޿�2�bѾ��0a&,x�Ӿ����f� xd0����c@֛��Z���]}�&v� ��v��Zx��`Zj_v0���B�$�Nǰ��*��*P�I�D��⼌.��^�z�M'5C�*���$]14w��{�~GM��m���DdWK{�����W՚!�R:j���mW3A(��`{|�	H��q]hҳ� �\�_��Dx��'�����e�a~�E����9���QT"L�1W��Fi�p��OԴ4�:p_p������c�l,Ơt�	�F�����`+�\�8Łӑ�U5�(k��>D�X���z����M�َa�xI}��Cv���&a!`� ��KJm�wؚ<d����i��5�RG�*��=\����m��{�gA�]M�.;�B'��j��qn�q9�:wc�e��Q��4k� ��Z��+<��� �Q#_Il �` Q��PȘ^�c�09n�	���F��)�U�A�0�'�cL��p�9�y�:摔�}I��� �8�е!�������I�`&�v��9�_]Uw�)�io���頁�p��Jt�>ԠlC`C*tT�bـ�My?���9���6��Q� �9��_R~EC�:�6��w����kD��E7��������$��������׈S-���y=[���������Ж�i�p���0g�ǌ�`�����o��u����e�����jc���<��v��]xvR����Yg�g��f���M�z���������g����k@ZY?�5�ҹ���	U��U�*�r�7���_����[veg���c �j�D���%�r3b��K�եr%W*����6�}�w�6pu:?"#�v{�/�_��%0Y`�С�fÛ�D5�����,D,ީ��[����Y5W�J���TO�ͣ����j�/g�0Qz��>`�Ђ{�}Ǆ^='QY�����w��܆���[|� �[b\�H�.("S\��k@�?Ͻ&f)`qY<&::=���"&C�wEG|�;�"�4[ z���/g����sp�h'�G��g5X���Xfc��6�ߗs���<�p��GYf���э��^��gw����f�:�M��i��zF�8�xL���o�νa��O�K�oc���8c7����w8L8v>X�����'��_,?�w^4�qa���Ea��YL}���.���ܲ -˰~����A�ד����<����wv �j+�!_�Hݳ_%�o
��Cہ=���]͉� ��������/ƨ�U�`�0u'�5��@7@Ѡ����XL�Pm�����c�G�kp}^�N�QV���{�(�-�WeG�(~��s�]��A3���=,x��3�����>W�_�#�]?���=��d�8'�;�� ���&.<��F��^���b|�	�afT
7�t��1=j��Y^���Yx����N�?���U�A�.՘G7��U`y�/Kb� �{͕�X��0�_�2�_<{�G쓀}�漕��F�~������������/��F�����������q ��70��GTR�.�-@�\�J���O@*e�ϫ��B�Q�ɝ�%.�8=�C�jV��v&/��E�:���!W�܂7>Dn��w��FG�SW�<��_*HW���Bi��XV����2��E��7�0�ɢL���И��̃k˘�F֑mЀP�'�9減���oE���x���U�?����m,��X>&L��l|����B��
��f�=^>7\�Qwx��6�TD]m{����.�(0�V/\� �R�R���R♈���b2/���1O ����N֌�b�]Sہ�h�`
�S�`J�h��y�@�T��%�|&��e�Rk�RZ�J�*!7�V/���K�bu�����#}يX���Q�F�E�l6W̞奺��KK�Zv��\z��L��A�LB�w�	��(�����հ�e�+R�V�UO&&��r)�G������.Ma����^apb�*�s�lT�����O�ژ�)`�� 4��`V�ф޹d<�}Cs{p\ϼ)ڝ�����a��]Â���ش�gb��k����G�F��G�
�;\��p����P�B��> _��z��9�� L:�d��
� /1��K|�x
�ſuxc��݊���-��r���+
h��r���&��x|Xv��s)�"��rS��
�F��>��w�� ���+�g���"�8�N�2^H=[�Fd��^���"W�(؈��% !O�O]!��ۻF���O͉�����ϥ��6:��������Z�������� ��߀���"���@��R	����Z1\��lL����/+���b����9ac��>���bC��R�S�4�Dh���QKۄ38_B�Ѳ��C��Û����6��Z���(�?,E����9���i��w�A���qץ(Ŝ�10j��B��� W
^�za���ᙹo�|�L7�0��Ć�������++��`�E���\"$&Q�z[d�)s�(�E漑2JxC$�ջ�V,|�榇m���h?���-p �&���K��#w�6V���qV����+�����SعX�Ƣ�o����!���e-@�����ᛯ���7������H�yj���m0
�s����*,��[���$�V#��\\�<��h$��"�	!�`��k����}E��W�t�[���$���"�"[O��D��_޶�|���R�n�������jk��]���_m]NV��櫉��o�?���쭿l��7��E�����Q��-�A���筧(��	8���<?�����Գ|3�.���]�������������2m,������B|����=V����VCm���N���8*3���[h�����4ʅ:��p�d"�p�S�ݏ����7.G6>���,/��c���w��Nk'[
��Q<�QV��4eFAl���N\N4ظ,'dqjB���V R�-���0$�l�RR����RbU"���B.�ʞ�R��j��\Rl��b�-���a3����qՐ��� �>����sFB��Rʣ�nVdkR�SH���R,'��:����;���kD߸�t�9k^�RM�Q��̾ו^�=��n�"[�zFU�&����{���i�Mڧ��1�iQ�p
U�+v����\��~G)�ʠx��
�S��c�vNҘQ�{��<�(ك��I�~t��o�K�Z@�{�J���-����`�T��B����E��^�q7'�O��s�m�q)�
I�`�����qّ���^��f%{��{�~��<E#�,d��_����R6���}�ɉɬ�sp�<b�݋J�P7��x�zrp|.8�4��r�Mr_�w��q�\k���AFnVTU(�O�� �S��sv�yX����0��W��|A��\ j�達�����b��~��[;�x.����{�����ԁ�K��Sٍ's��{�*练�ޯfI@N.�,&��T���-�ƸghS"�R-�;J���Q콞�ڿ6�'�ߑ/�q"��O_��9V��ڠ�觚�v�]bF��f�42�d�RnPH���{�m��(3�0�'��f�V����bz��WWW�H8�K���yU��ր�'k��_�����Ƙ��$z&`��-�pn�[���;�����!��ӧ���4������?Q�6�?�;鰜���H'$�)U�e�њ,޶F'��@�6��Q�ar�|>y`����mĞR�%��Tط��=ִ��IC�|p�sn�\)Q,[��}T+��B�{��S�W�u��ҌW�~J��nmxT�BF�B���e�v�s��í�8�ɊI��a>�_e`&��zJ�W�َ}�Q�|��X����_ج��O����O��<�<�n���o�����-�ϥ���;�'���#%�]!i�HI�EI�,)����̛��qۍ�,|�6��^�)e�2��BW��[>}��3�D�0D�n��;=]<�y[\0�}SoWsrZl���i�>���~��?4���vx(/q�������?B4���Z<)�Z$z2�,�Yf���8�eH�����X����P�{_9��r[*�v���0��b�� �F����նii�Ru�DL-�%��%qH۠'�r�[�G-�3�������q}~�Pw��� @��ɪ��U$����5�*d+���"h@��$�j4�@x`���!��n��}�vt28>�<<#���4��-xhQ�X��f�yI�ל;����h��td��h�y�j��0�����p��� 	��L��`h��_��P��0 |r����&ƕ#�'�(��D~��°
�D��������>)����?��9����v��n�����zR��.���"N\�pB $pA �vBHh9�u\����m���ͼyp��̳���������Ue"།v<�`����I��@�K���F���7�#L&`�
D��^�DSLț�>`��@e��$�l���B�]}�xC�H�q]9�jpz��X���(D�9i������:� �'ef����MП� �d����}	0�h2>��g������a�������;�:��5�]����w��?~ 9#���+��wKh�,�v�)l`obqeP�}�h�%��
�e~NNs��L��6��v��{�Ӵ��)��܃)�`~��{�FS�:���^�~Q��d����2�EH�fk�$0�$}y������/0�3����uB!��5%xk�?=���`���/\�x�_.j�n�W(P���+�O֘����7���:��J/Q-��Q�'$�LO>w6��9���#Y����!O\vn3}՟�އ�"�dM�]��T���O�T�l@��m#ޒ�C$t��pjM�@�Q��Sj�^;��R2����5��M�t��EE���a�,)k�lh�!S@vQ����Õ������=�q�ƑN�:76:ڍ�~H&����@�Vŗ9=�򨛞?��0�?uj��n�����@\�ȷ���E�L�zc �X�N����{�n�F]3��=�WUF�C��~݉XW���x,�ؘ�'����?����KN����?��?��|��?���|���/��������)�)�7)bA����￾���_`���hG6>�B�?�"�%2rTR⽸�$b�H<�z�d/I�㽘L%� II���H�3rfH(=%.��nh7��O�z���~�|�����������L���+3�[���ЯGB����
Yk�����?����a���p��{����o��_=�˃�?=X=����mG�0VC�1e��jlQ����澥3%a�5m���U=��*�Z��Ϙ%X�EXy�*" ��L���jہU\W`�5�v���	i%gG��%��sᬖ�: �-����Fa�]�E��i�X��9M�9{̶[�qg�YHC�/��v���
�M��	q�>*��ay܍�gB}`�lLp�����4<��[�-��v4c	u�Ϋ��%�y���Hl'��Z51�A��f��``��ˣ�ʥ�~�6�N²����<��V��7ٱn�E�*�Z�^�HD�˕g�ܞ)�z3		}P�	��͢j�#U�V34�{5?�4��|��'��A۬��E��i�}���uV�s�ZS����S&��7�sp>$:ń�7��Y�?1��h����0E�Y�i^�.&ga�yf1m���E�3i=���J��d_ǳ��e�ˣ�T�����L$���hZu:?Jӳ��+sk09�Ǌ����>6����u���k��.�K��K��K��K��K��K��K⮸K⮰K⮨K⮠Kb��
�`�%�l�h�-�7�,��ZEi�����n����T=Ü-�d�܉���hq��D�O��j΅���/	�{��z�(ڷv=�=�s=i�  ���杈T���!<�s��-���(Rϧ��؜���;T9fi�NKlv��,��V!:�%9jF��"����'�&�w�.g�'*j�m�������ϋ��TǠ{�Y:� "��ʳ�I%j��B�gK��d>i���s�R�S��x�BS.�I*�0�Pv�d����[jF[$bV1M%Y�>)��������+G�Z��iV&�*!Gz,�z��p�N�+�l�ݛ�Y���v�v^=
�ނ�������h7��sx��n�#��-�Y���ì�.���p~X5t��}zg����Kv_ل]N�=���_�Ph�������
\�-��G��8)��B?�&x���o���>�����<����%�ٵ�����L+��[�YE45�ʴe.U?Iʽ��ė��s,��|~6���];���H��"n5�yz���M��\�c�j6���˶6-���4=\A�7�(Di��Ȩ]�Y���qc#Hf-�Y�B�YR�Bj��&��츪��jD&Y��fGrfH�+�/���0R�hG�n��%�k��5��i3�k-O�������A�m�D�+��Ic��2h{I��i3j�C�i���F��1-��,2��4&� �[5�������������9�@���5�~��ۃ%}D�9J�\�Y��5Z;Q��I^��~s8<�"�r��N*0�P#	)\3����%`�
REG�ۣ�}f��㺲ߙ�J-��wyAo�'>�\��ڵJ�E���ʵv1���aM��J\�T1�i������/��7���i3@�-�c/@f���	_���	+r1�m/�gܢ�e݀i����i��W�ԝ���{�N���n�Ճ�_n ��i-3N���bly&[���U��
�j�m�MqZ>Ѩ��K��AK�5�Jk��q����cׇ�'W�5�J��Z�l��d�}^.��Ņ+�@�N��9�rV�i��Q�3&[�y�V[ù�0�Z5Ϋ��|���~��??�s:��Q�y���|Q���a���iL��'骒�+�Bk 6�1Wl�fE���x{�;W���"T���|!�dϥ�^w��-���S�b��D�l-a���ڳ����Z�(�ȑ,V�D(φ���DKM*Ô�>�	�[b_�#1�<�:�y΋u�K0B��΄����L�U|�3p:�9�:
�=�B��;�Fq�5��G���U��&��֐�L�|d0�&�kEӳN���Qn�/�)�әF�N0V�*'�f�8��c�2=�iDzٟ �r[�Bxe�CI5Km�<����GK(T��5�8j��3%:�b �BAܰ��Ca����H3�/&j�|J%���铓̼JφD\�&�h��&�5À��vd
��-0ɹU[F:\������2�
�W����Kc���q�#���wC�C�`&/��y��l�8�D�� ���3�B��$ވ���/�X����Ds^��v|�_!~-�*#sj���z?��i�O�G�<.��-�����;��_~�%��_�~�V�z�q�C��Σ��"4�,>�<h§��x�A�L����΁�����	�~�}m�Һj@�����k2��>%~�f����s:�����y�'���Ρey���b��]�C�|����t.�Ҥs���C������֟[��Cx"k~3�/�\��/��]8�!�~���U|���\��/���'��&�_OIV��|����;��� I!|l�L�!1z�L&cV�$�`����uN��F�� ���b_v���3	�6aMsl�y;�6�M_%��w�sH~�>aT��FP	�K��X����z���׬�Y.�l����R] ����/�[*q��\�,p ����Z<���5�$�p���HPP�!��D�tFA�G1�0E��g�Bm@��	B�������!f����o�0\$��w��I�M'$�[��7��L��P����a헧������ ��z�B�al�K��p�{�'[T�c�?��;��9�4\�+�`�6>u�A�3E7����ϳ��G�p�Yd��M�+�b �V��g}�(��d���mŦɹ.d���4��m�/dm���V��ڦ����|5P3<4��
���{H�0�\��E�$��@�au�����d݀�[&�U������D�����1�~�lJ}a{sѻ7o�P�h����`��~|���]������4A�_q�H&�iⳞU�E�c��#��C��.6��Q�#Ѻ��n���7޼Āc�-4Ren�qsć�����S5��I|�ˊ|���t��qq�x#���\�'a|<2��͘`f�Ö�ݒ5Qt�l]\��m�H�7��w��L����U!�����}�Q��z4�ٌs:@�=�谇1�{� v�ᔀH����v�:��f�^u�2鮕8�C���F&�z��CI�j�P@J(/�\p9$��:w�J�⬑51ts|=�U�7JanX3���b�y�y0''o3;sm8n+ �+�!l
��j�����<r$X-A9O�oG�2
ّ��~�\	Q����[M ���D:l����b+�KvΤI�	֮��/��e�zc��K�I{�0���c�-�83���wK�Ht8P����1Y���m%��+�$�(y�J���a�dfb�{��5�kLCJ�<�����eo�+"w���$_=D�C#��zl╵a��h
ݦs@f"���R7繡�WE�_t��,�c4ewBii�'"(���1Xwmqpc��b��d�ڍ�H���7�c�����|5� 8C$?�6#���������^x���8זq���D*�Z���:���>���|P�c��4�)A�!�u��d˝������4D��6Z�h��gO��)��YX�����A�%c��su��LC[jK||U.��,ǗnP�jں��):q�`�\S��~�r@4*�^,��� H�T&��DL�%z�d��Uz���Q D��?�����$A<�V@4	Ńcɐ��n�CW�8���4�2��ɧ]����8!/�����KCn܊-���9P/ƒ� )� �$E��HJ2U���  ��xFIE�ɴ��� 1(�tF��
$�C>����߱M>�?�Ҙ��m��u~��s�o���[�N��r�F1$�61ؚ�5*����K��Rg�:�y�����i��/q�\陬HS�r2�!re�e�\��,��ȥ����8�Pa����kH�뗷vɖ�+��KB�ʳ�d�Q���.Tah���.���X ��d�2Z�	c+�he-lN�aU��S	�������[4M��㖑������.�yE��D$���nJ��}�d���b9��1��K|�R��(����i���#?�h����+JG)X�i��I��S��V+|Y|6i��p8��Z�g`�LGnxu`(Ή
?�C��� ��n���.m֍�d�`�B�!f+��?-sb�R?`�yztܷ�^��8k��`�ýJ���J�*�k˪86�6DZ䜿,-����e�m�,s}�����e�ʚ�֚��~�}��A�p���O @!Ġ�S��$��_��;�ډ{=��!�mi�ս�W+������.��0UN����~�n���^^��ǫwm���ȟ���a��E������S��&�����?��������������l����W+���r���o��u������Ͷ}���[��FOw�����}?盻�z�,���z��#M���4ϟ�|x��/��%]�������}�o��s	�^1��&���P$�A�w���z�3^�����4�����o_��~��34O��� ��u��M��7
|�������P �X�7�?O�#�OS�s������x����|"P�e��@��?9��8����G��������3E?ҿ,�wg��?$@���H��Q�(&Er$�u��"�`�pa��$�T�")����&X1�(�X��M?�����!�gx�V���/$�F�=����?�Qi0Yf��j�w�Q�uG�r��2�Hʻ��q�������ϸR6�~�уt!���p�-]&����#�α���dJG~���4<�3��u���6�u��yM�1���d������ٟ�����a���q�x�()�{����%�O
��G��&����@��?(,��z ����7�?N��Q�`���i}	>5�����J�����G��ډ{)�,z ������<�?
���W��B�(:������4���� ��9�0��.�|��ԝ�O��@�_�C�_ ������n�?��#�����C��Q����?
��ۗ�?^|����Ak,�n)�ץZ̥S7Wn�?O�����z���^Z?���~^^#̚����K�'���<�>�e���ϧ�Obf�?T4q6KKƩQ?*������T��,�n��A�2kl��z���L���v�S+�b|�T��Cm�}\��������������Ϫ��7B�'5:�w]y�o�W������1X���l4^o��}����<w��2���̈�$ιSi�t�m)Y�j����h�ը������YG�.Ey��n�Ͷcwu��b/u�[� �����wm�@1���s�?,���^�.Q��E�������H �O���O��Tl�G�Ѡ�P ��N(�/
�n���?���?��X���7A����!������b���_������a&�x�Ѱ�6﮺��%����q�cX�{���T�/���5w-��a@�`�Gun&� �7�����U�.�d�᭥|!4J9�4#�)�$i�rS��#�5T������[���װ��>��eSίq�������7B���ڹ���;�'���_{��a�6�r��еM4I���O/cm/��9���(V�j�Uґ'r�{`�|w�ʬ���󊩞�+9�H#CR�'�zfoa��@��X�?���@�� �o�l��!�/ �n���3����#N��JG�$OE���ȑ�$1��a(�!�3>/�4�$�!�HL@�$��u������!�G�������^cz�(�v�R�x"]��~{��,��}^�V��&	����-���ܳ��>�ǻ�Iz�=������p������m���j�X2j�n-I}�in�M���*
��K��n�9~T������?�C��6�S�B����_q������0`�����9,�b|B��������,[��zi��'B�;�3��Ļ��V�Sϛ�����S��7���Ԥ]��uL�����U�9���(w&��<��%d'Ik��ܞS:�s�6ڕ�N��y���.���<�������oA�`�����xm��P��_����������?������,X�?A��gI�^�������;a��*��n1���'�ax��M��?�ѓ�e�I����g q}�3 �o��� g�V{�p*�U��e��3 d{?Z��!�K�l�4N�%=#g�vD�K��Ҩ�F���:�֩���.%V��Y�Jg��@۪�\�����N%+[.���D��w�]?y�
����U/3 l���r��J�W���$��+�h_����[�}O��:e�z��Db��5h1N+�X���j�Ё`�cS)���2�F~�i�Po��4ʦn���k���n])�Ѯ~
��pب)��p��%��G�M�]��VS�(�X*�Ϊ�=�/ϳ�ʬ��lc��<9(U�g�zc3��n4�A�Q��ǂ�C����C*<����������x�?P ���;�?���H�<��*��E�N !�G�������b��(��/H�%���A��H
�Qt̆�/�����ȋ1��e���t$J1+Ĕ��14v~p�����r�� ����Z�nv2�.7\��.Mp����d��Y9;�6=��[&��������h�`�����ة�ZU��mj⾔w��QZ��"�Z$���֢���s��G|gW3]�����*�^��m�̢����?�ޙ��$�x��X<�-?��C���i��� ���������-&��#����������A�" �����8���_�����������P�Z�m�Z˞U:Fe�z\��J������TH��&�O��:m����~_^#�S�}9�&~Z���}����>'�?�V<�����Nl���N�쭚{�L�����xmL�;ݺR[6g��0︣�ߐ?r&�<�[�h9���Q��{�~�&yc��*MSf���,W{�z��m-�^Qέ,���C��m�9���z�ġ�Z[R��愮s5��w�Uىl�j�*�6l�P�dt�1+�'��K���+	���β��=i�F��H���V��*+}��FnJ��!=�����Qe%aYnGƺ,p�g�����q���[�����e�ׂ����7��ߩ��i��C����o����o8���q�/�����n�����q@���!����������( ��������[�����o�
|���K/����	��������	p��$o��P�������?����B������p������G��!
�?����ݙ��H���9j���_�`��	������.�x���M��?��!��ϭ������0�h) 8�����@� �� �8��W��s�����X�?�����!P������H ��� ���Pl�G���#`���I��E��ϭ�����{�{����H��C�?r��C�q�������?:�����G��C��,>��jC�_  �����g��0�p��:����>�� 2�8�x��J,����b��'B�_
(��%�e9������8�?�S��o��v��#��i�ç��Z;G���"P�J��%7`�	Iy��4V��4�<���P�ت��������Ӱ��nܑ-U�;۽�ڮ�Y���T�U�t�u�*qB���{�;ܑ��c�����$Q����Z��-:��P.k����j]2^Ċ9^������K}�1�?�����l��������C�Oa���>��sX�������!�+�3�k���JY��WJ�ƚ�J�Q�֦��ԩ��f�j���֗�c�׍g��s�̶֩J]z��d����`L�n�I|�cSv�;%�v���p}�ʛ����-�^��d�N�,����Y��x��7��!������O���� 꿠��8@��A��A��_��ЀE �w~����A�}<^����_���S����-�tv:݋Jb��r�WI��{�vi�)��U�u0����x�1릻���a���g҆g��p$d�b�H6��QK���4�T���y����F�IS~*�N��1�e'̈́_�'����VjVW9q����㕾x�]�N����nE�M�|/l�D�(��<�M��f��˵r��c���)Z R�l[���"1D��-�i��6��f�P6u[5j�!p7�f��43##����84�����R�9��D1:����R�_T���Y)�dz��k��6̬<Z�9ac����x'���Q�}�<��W��Ҥ@����I���_$���>�������O����������o$������%^����:��$E�� �O����/��h����<=�*������<�w��(�R��ꪪ����~a�����3)IiFc�1oN��@���Mv��?T��a�*�>dܴ�z:+�o��aV�kʏx�܏���5�g�z�x�g�S���$O���%uy�\^\K�omK�]��$�c��P�f]ME�/uN}��n/l��R�ϝ�N��Ƽ�Х�^%gk]M�Q����	��J�5��e�ZeNɚ���]w�W��I��'�xoW���r��V����7�t�;?/k�$C������q}s���]+������Ğ(�"��awÔ{�<�~Lu�en'�}�fs�iLBmK�|֬u�e��&k�.Ozܜ8�B%l���Î�^_���` ��~A�s����SJ�D��e_ɝÐ��� 7���'���;?v=/�KNK����7��,�wS�翈�F�	G<���0)���R��e����$͏F��2��g�������c2�"���(���������!�����d$׼lg�'�< 	݋��^����]\?|�3F=������V�|�V��ȕ�Z����⣟�K���?�%�������[��?$@��C�c�X���m��	^��5O����5�gd��M'J[�-]��h����.��_�W������.	6�m��ٗr?�=��K�xE�o`*�S����{J������$sj�r�*5��ۻ�fE�-��_a׫x�:|ydЎ�� �y��� dRA���{���y3�*�������^@�����9{���yZ)���!��H���CsYs�N��dm�(;.�[8M[�Y��=��8:.H6�����ˑ}e��!�:�w�C����pv�E-��R���&R�펕��>�[{�����m"���Xgf�ֽ���#{�3�\ϺI�ba���Cw=�u�����u7>��&�ڜg���(/^k*����f�'���?���E�Ľ�������J�n��*�U�*A�3~:����05�Rq��V�d���e����d^�U`���������*��o����s�OlЮ/�F[��Ʊ7B�5anl��#9�wu��i^o8/��/[RՂ|�l���[?����7��1�Y��/Q{�����x�մ�Vx,$��������������
����������!��_���S����������������PmuCkon�����0ns��������♝\�}���j��|� ��Y}$T�����N�����l�m�e[�öx�Zי+�[���3W��ҕ+v�ryma,���fߗ���y��pV*��2
��؋���z�\
G��dQ�{�����z��Ǿ1=��:�p��-⁻�����r����Z��K�N�-�w,���Ɨ�����|�e��e�g���X޲��=����%6�kc�����5-^n�Bp�<�xIi�Xu���Ͷ�}S�U{���Jc��������pS�]u�h��`0b֪�ȪԐ�5�pd�aM�;ő0���Z�p��}j[U�?�}�_F�~o�o���Y���
�Q��c�"�?�����H-
���2�g����O����O����V��s8�?��+���~Ș���`(D�������L �o���o�����ޢ������]~Y|�>�'1���A!�����ό��ߤ�C�P �����w�a�7����`�� ��ϟ�	�&���y�?�B������������
�������?���l���L ��� ���B�?���/�d�<�����[���+7�������P�
���?$��� ��������A�e���"@���������� ��9�����C��0��	����������� �?� O�:�����[����;����	������
�C�n��������E!�F��ON�S���Sm��� ��c�"����a���P��i�L�2KJ�k$��Kͬ���ҬT)�`����n�ZMM�P���0�Bc4�>|����"�����!�?���{y��E��0���R���͵%�m���-����Xhp���@�o���5�s��յӈ�#�ءU��7	���	�k�+:`�6o�t�z���n� N�|\&��n\х��$>Y#�X*$v@遪p������%
�{���*3����U�͓��jk��+��x���n����?�懼��h��E@����C���C�����$̻E��������8�j�^�):�0$f�带�4�X�f��}$���|x����d�]v������v��D��g#���=�G89l*U��3�FEGwMs�TTN�V�HZ/w+e�Kb-��C�\��}-���W`�7'���������7B!��+7@��A����远�@�B�?����_���߳��~�ݎ�Z[u`�'�$pC�����8�����%�9�[H�����t ��|�y=��b2˵��i��0�;\D���n��6Yv5oVf�q��gf<-�3�ȹ��k�$�
3�����koԥ_Q��^�ǠG	͕V�vm����K��U�ȶ�.���p,\�&+�,A��z��L!�s\�H��:��G�"9ND_�\���:�X_��^K>���'�������qv���}I��F�T����u�s6n��q^�����q�&����a�:&��Ԥ����.aj�qT�A��|�Q��S���޺�9 �=
�,��/��a7�&������G!���S�� �g������k�?���?���O`7��b(��,�+��E`y7����?w�������O&ȝ�_-�w[<"����s��N���f�"�?�@f������?&�O@�G �G����E!�~g��_&�]��
��������X�!7��a��\P������Š�#|������?�z�B��q�SG`3zi�7��(��=�/�1�\��V �V��~��H?�+�i�����67���v�u������~�'6��̞�i�\�{���#5�GN�e��;]��y��Xo�4m�fyW3�З�� ٰjN�3WT,G��IZ��|k����S��j��u8�vlJe~Rf�H��;V����\n�)+��g��ܯ�e��qZ�f�����Npld�r=�����(��z�H39k[�n|,��M�9ϰɍQ^��T^)$����N2c�g�����sC����"�y��#���������E���0
�)
�����`�?���������0��r�ϻ)�?��+�S�N(��9 ����!�?7|)������W���n�m6�9�T�(kԞ��������q,Y���Awݝ��e
T�����zwb�p
Ȟ�T	�Y�몎��VQ�;l��C�+���E�谭���6v�2�QB��
ww�P_�d�5�� I� �J ��Q� f�+[��l����2{�G��mH�� �3	��-����9`5����܎4+����=�ro��v�F�e͜��N����3
���;뿀�W&�]�}X<�xL@������_���?V���@q������VӤU]�UUcY�4¤0�&5�"L���5��uS�4)��ڨUbI��÷����(��[������\�s�,��CzU�5_���H�y�wT|5��b�U̵ḥZ����|���y�ʺ�B[��{k�� Қ�c۷*��9�
}�:Dyu���9J�y9m��x&�f��I |�a�~4��?�E����3?�����@�� �"����B�?������e�$̻)E����������~3�W�֓]bH]��t�u�a���?G}.v�����C�D�ƣ��~�l���A�o5��G��0�fXe�hb�.OＯ�_1��������ن�ɍ7�9;z$��ע��M���?�������
 �B�A�Wn��/����/�����y����E�U�������������e�>=�=%��j�w�w�����/5 �S�}[ r]�u@ym�{u#��NU�e�a��b�agx��UM_ۢ1�u�D>Ր5Z�W�*�hz8F�[�*���<Sj�����5����u�͊���Oe��<Ne�F�E�q��*7�9���6N�C��E.n�� �
�'��G�qӯV%/kJU�y=b]s[��KSҾ�a1�\�<���*��(�Ѭ3e�;ԧBz.7>�[}ԋ�gƁ�G�&���@i_�yf"�=�[�
1fOkq�#s�V��j!$O�u�ע�M��AhN�֚���_��� ��k��N0�i���q����f������cd��>���+��t�ᕒF�FF��K���ӧ���IuF=�� *�,7����(�ﱣ�/?��u�r\tLO�����1J��/�{�
R�1���m������V_��>���Y��OZ����۪�����H.�e������ec�-]_���u�˖b>�o��}�ӧ$��<�����/������O�i�<�o���9���� �(	G'*m���aT2�`�������&}b\�[�OHhD�w�!}��Z)����#9r��m�R�����J�������T�H^�ʱ���aw<�����﷟J��S��,��2y��y~˯�	~���s� ˄������μ=������)-��������w��>c5is�'�6��2���(E�����x���~k^�/,�vB^����*m�
>��KN�ҧ�:���������/��Q�������� �noK?�z��ߐpc���M��B�����.��\���|���m`������K��ﶥ;1�1�%$�9��͍������=�N/V�:��]R��n�铻x�����@x�������w;�,=wT7�!�Ô�.�~�I�?}Uì��}�}~�/]Y��~zB����   @������ � 