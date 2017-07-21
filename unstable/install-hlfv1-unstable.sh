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
� �rY �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�l����ǟ0l,�2O �@��
��� OK���x���Ї���.��)ʆV_U��KQ �<a����_�#�:��t�wǹ$S��m�����`���(?�R�4,��� �w�f�o��A��Z�ރ�3BJ�
���T>K���\v��g �q� �	[��9)Cס�NZFK� ��֒���?K(Ө6��	%�sP�k�i�K5qq�z�@�}6�̖s�_s�����a]�*�a�H����G��W,�D#�ʚ=���ADf&װ��B́��M偙� %\K�Ĵ-SٍD��ax!�Lb�v���3E��R>�Тtd4Q��Q�FI3�=�̥1f�j����,�"ϙ�k�;�c"�9l����g����2�ݽ�!Ǆ+��u������`�:����2��[,[Gt�9�nʽ��� C�$j��:��S�K�ZEJ�N�<� ?�}3Y��/:����+O��Z���4Ѥ�;�q�O���ވ������b�����|<.ܴ�c��q�	,�
�'@xpJ����ϙ�V����;�m�̿p����矍�x!.ph��<�m�u���"U�4d�Cنk)��_ �I�4U�<��cR��UJ�rJz�|���K|�=0M�+r�2Z������s��>��O*�\l#�뀍��0G�MY��|��6�i����?,���c9��1��ᣛ�-�7Z���,3�-�;�0
f�:�ۀ�	-P!i6p�G��|L8d�I��eXh�Շ�ab��?m���7Y>���e��X.$I��tkʩ�ak�u��HD�܁!����!��5�w�tR3��ґѮ��L�Csq�l�w��wԄ:ڶ*��ADv�����,�pU��-���	.�v5�B�v0���G��$�ׅF =��j�5�5N�G�y�j_�^��^$/������A%��sE]m���
���DMK���5����9&��bJ�К l��: h�Q� ��@�ՉS8�]Uӈ��`��C���꺪��?
�Ը��拗�G�:d���h�B����x���CY����^�*u����1 }���u˨��vh ��~İ��4��Z t������&���s7�^Ɲ5�L�V�
A��۽£��5���U11����5�>��㶘p��m��� �^��N{2�;0�ļ��#����cI��ї�_+B�`��]�	�����A���`rq�h�
�����EQuG��B����~�(�:�D��C�66Ԡ�AGU:� ��Д���{A�|�`C�ur��Ӹ1�%�W4ԁ��i�+x��8�FDx_�p��	��=��K"N�hXP�~}�8����׳i^���mY���7���
s��H��������f�_l�?_6̑��|�6�?�s�i�g7����g'���/�u�y6�kYzڴ���1��h
[�YKnxF�kY��5��cXC*�+��A�P��\嬒*��{C�	���o�eW�w��?���1I�X]"+7#&˹�Y]*Wr�⫋�k��7z'�jW���#2�m���"p��\��� 
j6��NT#�
l?��B���,���X��Us�T��L��<�Y��!����r���X���-����wL(���s����{��mx�����`�%!�卤�"2�e����h����kb���c����:��+b2�~Wt�Wq��.BO�B�'���r�9�_A;�vr~d�}V���?�e6��z`c�}�0w�'[�Cn �?�����8�k#��/�Գ�Z}�t�TM���Pȴ`K� �uU<&�_�7Z��0G������z�g���6����w8L8v>X�����'��_,?�w^4�qa���Ea��YL}���.���ܲ -˰~����A�ד����<����wv �j+�!_�Hݳ_%�o
��Cہ=���]͉� ��������/ƨ�U�`�0u'�5��@7@Ѡ����XL�Pm�����c�G�kp}^�N�QV���{�(�-�WeG�(~��s�]��A3���=,x��3�����>W�_�#�]?���=��d�8'�;�� ���&.<��F��^���b|�	�afT
7�t��1=j��Y^���Yx����N�?���U�A�.՘G7��U`y�/Kb� �{͕�X��0�_�n�X<{�G쓀}�漕��F�~������������/���_����������q ��70��GTR�.�-@�\�J���O@*e�ϫ��B�Q�ɝ�%.�8=�C�jV��v&/��E�:���!W�܂7>Dn��w��FG�SW�<��_*HW���Bi��XV����2��E��7�0�ɢL���И��̃k˘�F֑mЀP�'�9減���oE���x���U�?����m,��X>&L��l|����B��
��f�=^>7\�Qwx��6�TD]m{����.�(0�V/\� �R�R���R♈���b2/���1O ����N֌�b�]Sہ�h�`
�S�`J�h��y�@�T��%�|&��e�Rk�RZ�J�*!7�V/���K�bu�����#}يX���Q�F�E�l6W̞奺��KK�Zv��\z��L��A�LB�w�	��(�����հ�e�+R�V�UO&&��r)�G������.Ma����^apb�*�s�lT�����O�ژ�)`�� 4��`V�ф޹d<�}Cs{p\ϼ)ڝ�����a��]Â���ش�'��7��������������N׼�.\��%��9��� l��fv�n5S�6Y���6�K�i|���b�o�X,z�b���|�w�y������Z2�����{�7�?k�e��>��-��0,75�Ѩ�n��:�s��{��Ґ:��xvQX�+�-a �#�D/����Գ%�`D�<��/�!rU���؉[B�t��X��kn\�Ԝ��O����\
���g�c�/p1O�o���>_��8�9�0
�a�X�
(�j�
��+��/J_��U:��d�;�����K!�����6��z���/6�-U=��q@cL�6]��M8��%D-+��9�@�9�ٟ���qn����+��r�òQk.<`�C`Xm@�� �|�zg����Gp]�R�9#�o,��Q�r��_��,�����G��pC�C�Ol������L��2� &_Y���U Bb����E�>�27�b\d�)S��7D�]�Kh��'nnz�&������-:��o�-~���?�pwhcu�?g������_+1O=���Em,���i�O���_���|M�Q����?|���_������֟~����<��i)���	��h��N"k5��eȳ���F"�+2�	���Ǝ l��W��~EMW����7�O�ij*�_�!��t�O���m�ɷ�)*e�a9����׭��F��u�������d5�o�������y;�����?�[��������R��[�z�2�i�����0��~�kX��O=�7���O,ܕ�X]�G���_�q����-������?/�7�-���cX�o5�&J�4h� ���0�i�����=�A�\��|KV �g:���H�j{�rd��
���``<�h1J|'��v����%�sQe��NSf������D���rB���&�qmi"U��k �NCR�� %���L.%V%��^/�r��y*%*��8�%�v�,ݒ^/�6#���xW��R�܁q��<g$�;P.�<�A�fE�&%;�T�^��.�r�]�����n���j�F�+K�s���)�t���{]�e�N�<�v.�U�aT�lbxz)��o;��ۤ}Z�s��e�P��b罞����w�b����9�P�1�j�;�i�$���׏ϓ�=H���GGYi�^���4p�w�d�������i_�	�IU:.$���_����qs����X8����R��d�8��X�X腊��l�Q�Z�W�7��S4��B69�5[)�	�-eS)��@����̺;�#6۽�Tu#ߏߪ'��K�q8.W�$��|���ʵ։| d�fEU�B�4~j�;�J<g����)/����y���D����H�����~;-�X�I��#��XHٸW���[H��d�:��x2�L�׭r�;8��j����R�bR�XA�����݂h�{�f0%2m� �R��o���)��k�z��2!'"��U<�`E?��~�i��� f�o�M#cH�,��Dܭ������2�S|"�okeq�NX^*��}uu��#����W�Ǌk���O�eX�n��-��l��=�G�gF��2�6�E��Q���_��/:}�o`M�`����eYas�s-��˹:Z��tBR�R�\v���mkt2�dlC�&7���I��F�)uZ�L�}��cM�k�4T.�G:�v�ɕŲ�O�G�b�,Ժ�9uY�{)�xՀ��_�ֆGea(d4(���\Vm�:�z�0�j������t����U�`��1
���x��ا��>����]������d����]����c��������Z ��ג�\*��g�ip��?R�������Q[�����2�\ͼ)\�݈��7mS>�E�RF)s�)t%���ӷn=SNtC4�&{p��^:�����������7�v5'����^p���S���� �C�1p`IKm���� ,��X��>�#D�����3�2̡E�'s���e���i���lP��/�a���<L����C�/��Bk�Z3!�Pmtɋ@*Ym�!��-UWIĔ��Q]��^��z�.��5~�9�m?0Iz�����7�u�@Q���@ ����� _E��m\#]1�Bf�!���(�Ԍ	AªF����B��F��7lG'�����3�Ks��ڂ�f�%�ſm�Q��T͹�၏;�VM�A�8��鐗��/	C]nhп�G;�� ��D�
��k��y�k�
P�'�]������q���I6
C'$�߾�0�B3�&�e��n{�OJ��m�����xl�jw�����n�m�����`���$��\�8 !�]�ZA�p����p���x3o�(������_����_U��6��`)*P|�R>w�������F;���	X�Q"��5���X�-P٦��I-� ���eW�>��8�|\WΧ�^<!�>�~�7
�|N�`d����N?��B�#gl<�`��'�.�A9�,�y�Bc_��y&���7���ge�>fA�'}����pMbW~������ϟ�_�H~�|�J&����� ˇ��}
؛C\�f�5�@u	'�Bn������6S����퀵����a�4m�t�� �`�%�_�)�����N�!�׹�_>:Y&s5��o���Z%	L.I_ޟq�4����{�{z݀PH5��DqM	�Z�O"l"5F.��!x�ׁ��Z�� ��������� Ó5�#�)���1��o��KTK�@TC�	��8ӓϝ��@|��HV��c|D����L_����a��4Y�i�r�#Uy���5,P�}ۈ�$:�	]*>�ZS$hT��ԄZm��,`�����sM�s�9*��DQo�u�.K�.Zt�TP�]T����p廆�k&b{O#G\�q��m�΍��v#��	?a�2кU�eNϟï<���!�;L�O��&�[����2�F(�$�v�3�<���2ְS4�0��j����A�L�o��U���恤_w"���*�$6���(���O��C����}����������O��7���?�˟�Ħ�z����!�C��m��M�X������ﾵ�+�6ڑ�Ϥ��Ͼ��z����x/.+�X2�ǥ^,��D��x/&SI9@RR`o'񌜄JO��i��}������_��,���G?3v������w>���V��~$���?@��B֚��� ����nC?{���+��������WB�� �OV��-�F�c��`Lz��[�*�t��o��LAI�gM�a�#FU����J�Vc�3f� V�mV�� �:�u2���v`��a����vBZ�ّyyIG���\8�%���i'��BA�g�t���EZ?��`sN�x����|�f�P������gS"lB\���}iXw��P�9qs��;/���eK���XBݶ�*�a	n^>k7�	o�VMjЮ�6=����`�r�.�M���l�=6���U��Mv���bѹJ�֪��_�r�Y�:�gJ��LB�D�{B.b����H����^�:�AcE(�n�	&�~�6kcb�!n�4B�-�1F������<���ɩ���ME���N1a��xrV�O�E�=�����&L��C�u�W���YXo�YLp�`�LZO,��R39�W��)w���4U�|�D�6I0k5�V�Ώ��l,%���L���"rD�'���Fx�<A]�~�Zm����+���+���+���+���+�+�++쒸+꒸+�؆��B1�w�7:z�M$�?�VQ,r;����f'"U�0gK*Y.w"z=;Z\t;�����s�%��K����%
���]�|��\O�.��{�y'"n�~����{�jr:����46g���U�YZ���ݳ�>��F�U�dI��Q�Hk�DDk��x�	❺�˙�Ʉ�c� �D-y��!<��"�'�1��~���#��4��lyR��z�P��Ҧ�)�Oڱ~�ܾ�����,��PĔ�e�
5�'Ԅ]1�&k�F햚���ULS�A��OJ)z���� �p��ѱ�lv��I�Jȑz�^/;���C�
-�u�f�EV�������C�B;���o켶�6�����n���{�n���8��0�l�ˢy>�V]�.B�����Fh���(�҅�W6a��e����)ځuy3�F�5��e���-N
�ƣ�O�I�s������ �;B?x�?G�v�)+-�)�����VzVM��2�E�K�O�r�{���e��K7<���n�}��9����Ryl���D�t���"n5-ᘮ�ͩ�鲭M|"0M�W��F(
QZ"-2j�u<�r���Y�iV�Pc�T���&���>;�*���IV�ّ�R��0�K�¾6�T;�Q����CI��m�;q�L�Z˓a��j��xlPi�8�ce���c�ڞE�awڌ���w����x�idLa!�ǂ̪5��2@�C��êF7{����~*e��q-�|��s�ߢ��`Ik�R-h��h��N�Šz��(��������⃓
� �HB
���iw	���T������p�)����wf�R�?+��]^��ɂO�W�{�v��dQ�,��r�]�|sX���.ULuگ//���K��M��=�_��sK����a���G��*&~\L`ۋ��(��EY7`櫓~�}|ƕ<u'n�8�?��n�`��H-}Z��̅�)�[�ɖ��rUk��Z�F�yS���;lm4j(�Rx��jͱ�Z�l�`�%����a'C���y��ң��=�;e:�h���gnq�
-ж(sN��h�>r����lޠ��p.$�V��j�0��zo��j�Ϗ��N�D�i���j6_.��dX��}Z ӣ�I���;�J���My��Y�`b=�������Fe�x:_��ق�s)��-l�kd�Ԡ�"Q1[K����b⿺V'�"r$��#ʳam<:�RS��0%�b�Ė�W�H;O��d���G�������3!n��9b_�L ��yΤ��yϡ�9���Q�j���Qv�o&�F�#��#�5�2.���I�Z���Sk�j�[�c
�t��.��U��I��4�����LOg�^�'ȣ�֡�G��PR�R[<��3����
U7GvM-�Zb�L�λ���P7,��P�h��5��Ƌ��4�R	��EwD��$3�ҳ!ף	�2�p��h�0`�Ƽ���dLrnՖ�f��B�t��L����*e����*�}�ƀ������;��-�ɋ~o�)��7�����0���E��л�7�7��G����7V�+�5ќg���W�_@��Ȝ��b����E�i���?��hhK%�0�����_~I}�嗤߆���m����h㠈 �'�7��i>#�c�+�c�k�s`�e�|9}B�_ f_�����?D�=�L��O�_ļY`7C��N�hv�~���y�}�shY�(����Dh��Ѕ?ߦ�C�.���4�ܠ'|���9�}�������Ț���?׼��$c��G�_��{����"W��K���I�I��S��z=�;��t�N�31CRH�/�}H����$�E�ɘ0�1���b�Ce�!�Ѯ*�g�ؗ�.���C�p�MX�\�w^���Ms�W	������OXUa�T�����$��g���i�5�z��/[/���D�T��t���Jn)�' �E4�����}�	:\��?�� ��@H���@'݃Q��A"L���D���P�g�����AE�c�o���� >��F$ɩ�]Fkbw�	I�i���.�#�,�(�r�iX��#/ijy6 ������j[e�&$��������t�O�����pe;��7؆ ?���O�{�bP�Lэ1."����Q��x�.tS护���ը�Y�$
��?Ym�a[�ir���6�=~��Y;>3��!��i(l�5_�p ��q�B0zE��R�)�)>z�=IneP`X�h��6�!Y7 G�Ibթ*���;�}�uG�w�5�+�R�D��\��͛7�;&u��m;ذ���:o�æ�#~��DP�W����a���g~������ȵ��| D��M��iԵ��E��xy!���.��Ā7/1�X|��C�[k��!nE��y��T��Dgߟ��"_)��]�k\�9ވ�o ��fW�I�L�d3&�ٺ���u�dM#[W��x'R����]G�&�h���qzDHti)�v_`�����Mw6c��x-:�aL�� �����E8% �l����Y�W]��A�k%N}��<�сɨ�6��PRz���F.�ʋ�\ɨ�����8kdM�� _a��R��<p��ck�I�����\N��
�l��d����c��.7�	�FKP�S��Q��Bvd�_,WBT�{�v��A�l�2р�%�������ĹE��݂3iR`�����ml٨�����G�^2�&�Xo:Nǌ{�8���1T�4~kL֪�d[��o�J 	*J�9Bzr(���`�u���Ӑ�� p�����GٛF��"<4�W������xem�i*�B��P��H&����ynh�U�@��j!K�MٝPZ�
��b��D[ܘa�X�1�vc=R~��q��ثq �8_�;��O��﫳�m�a�����^��x'εe\��?���V��ţ�����}%��X!>�~Jhh]'*�r�c+�Ek�7�+Qf<���9�����,}���xV�nx+?wPn�����\}+ӐŖ�_��:��������N�=+�tĵ_��ʠK$�( R"��* Sb�^2��v�%�z Q)��De�'�2I��M�Ss�X2������+�=+8ͽ���}�i��t�>N�K>�)���Ґ�bK��sx�ŋ��2@J&�$I�x:���LE�x72 �d2�QR�t2�Ā$�;$@J2�Q�)�I�@��O%��C�wl�O�O�4f0p*q�_x���Û�����Sg�ܶQ	�M���Bx��n�}�R���Y��u�+su�tZ��K�1Wz&+�T���o�\�f�:�h<���*r)5���7N,T�gx�������_�e�Fe�Ш����u�讫U�co��� ���9٩��g���
�ZY��nXլ�T�bg�k�wD�MG�Fg�ed;c��8�ĵF��w�EQ�-	�b����o_"�>�XN�|�_������94��|9Z���H�ϳ�/g+��Q
�c��u�c�+��
_�MG��0������'ӑ^���s��Oᐼr)H��%�īK�uc+�#��Pi��J9��O˜تԏغg�������;Κ�E"��p��b�Ҡ
�ڲ���ü�9�/K�4C7�gYt*�\A��4��q����_���9m�پ�W�w�4���4$Bz9�	1O������ر㭝��C�E�	��ګ{w�~�@O�T9Id��ź��Nzy��޵m�?#��?x����2r�:w�GO�����������bﻦg��o�����u~��^�L�������=���2J��z6x7����o�=��������o�N뽳���]x��4�_��<���y�T^ėtѿ����������n�%�{���(���A�0�޹����x����I�$��}�o�-���<�X�sԭ�7	��(���6OC�-cC�b����<��8�?M����:���お����D����i���r�Kq4s�����`?�3`?�[�g�~�	X�?���/�H�J�ő䟣�QL��H#��,EF����8�CI�0�ER1!�	L �b�QL����~�����C���ԭ���_H���{>&����`��&���-�j���6��e���w-�=L��������q�l�7����B��[�LL7��GX�c���ɔ���1�ixgjc�ԇ�m��l���cH)���R��s�ǳ?��������������PR�����K�� ��8�?M���3��(���PX���� ��/��o��  ��@��)�.�|j �����p��������RY"� ��/��9���y�����>���*Qt@��?��di���)��A��	s:aN�]��.`���;��P���Ї�0@�������� �#F��� ����n�?)
�x)��/������Ճ�X�R6�K��K�n����
��Me���ٽ�~�����F�5�ͽ���O�m��y^}˪��m}�Om��̦)~�h�l���S�~TQs3.7˩�qY���i�:e��p��<�Ǚ\i��~�V���T�X{������q�����r��S�'�+}�U?�o�TOjt�����,������mc�:6���h�ް?��T��iy�N3e�뉙I�s�Ҥ���R�f�4
����%�Q�C���}�q��\]��~���!�m�:��=2�^���������� 
)�b ����X�?����\�P������ ����	�����������A�� �/�$P�_ ������7�������o����C���������9���������L�t�a�'m�]u����J������ǰ>������8�'^:�o�k�Z(�À>�<�:��L6Afo:�!h���]���y�[K�Bh�r�i(F�S�I�����Glk�l�5:�e��,SO�a=�}\˦�_�z��'@5e9o<��SE�sc%w�O<����9�m��;�k'�h0���O�3�^��*^�3s(l�Q�r� ��#O�V�����(�YE��S=�W2rb�F��=NZ�������������G��C��,>��jC�_  �����g��W�/8�G��?��8*
I��8�X�#9I
b2f1�PC�g|^i&I&�C�����I���������C�����?=5���0QV�r�l�D�J���$�Y*1��6���MT�G�[#g�g;�}��w=Γ�{T�;J]W���mg�C�އ��x�d� �
Z�&�D��f�l�U��	�T�ݲs0������?�����l��������C�Oa���>��sX�������!�+�3��Y���5��~�O��!v^g��k�wgͭ.��79'NW���Oo2|K�I�<|��uimի>s*��Q�LBU=x,9K�N�2�~��=�t��Jm�+u��"��4l�m]&l�x���?�߂������ۿ���	�������A��A��@���X���p��Β������Y�%�W��v�fUU���b 4�O�����?�����'��ʲ�g�5~� ���;f ��ٻ3 �R5����T��T���g ��~�b;nC.��يi�VKzFμ�h�*e�Qύfe9u�SUO!]J�N�)4��Ϊ���U��՛��JV�\L/̉ĳ��~��.>��^f �nE�M�l�D�(g�I��WhѾ\+'I;�����"uʶ�X9-��Ek�b�Vj�n#5����ǦRR+Ke����R�*��p;i �M�V�� �ݺR�]�*��QS&��H3�Kbŏ6��N���<Q��T��U�{T^�g��Yc����yrP,��?κ��f$��h�����;�������>Tx�����y[���<�� �O�w���	��?x�aT������@B������������?Q��_��?J���  Y�"?��I_�}��Y)H�c���4���H�bV�)��ch��0��ߩ��8�A��Y�뵂��d�]n�{]��&����A�rvlmz쉷Lves�c���т�:��G�9�Ss�4�����})����֓E��HZۭE���I�e犧��ήf�.-5�[Ub�Jw�"�E�_���3��?H����x(�[~����?OӐ�G,�����C�"��?ZL��G ����4}����?D@�������q0&@�����N��C���/翡����ڵ�=�t��J����>��7��ᩐ�oM���u�����F����r�M���;��v���}N�R�xċ��՝�8(6U����[5��5��)��ژ�w�u��l��=a�qGC�!7*~�L&�)x���5�r#5�v��X�XM�ƴ�U���V��Y����~Y�Z����[Yl='(�"�Ns�7��C�o���Z��	]�j���n����]հU6m�<���&�cV�Oח��W4���e��{�^�ʉ�8\�_-��1ZUV��׍ܔ��Czf�퓓��J�>�܎�uY62���j��4���
��?��Á�����-�C!8n�!��S������P���P���p�����_6O!�% ��������“��?B `�����9��Q ����������;��$�?����^~i��p(��-�?�?���4I����?
����e��-����������!
�?���O��� ���?�C�������3��?� /�s�@�����������?���]��.`�����/� �:C
���[�a���M��?"`���R p����?0����� ��� �p��� ����ϭ���8�/x�?�C������ �������������G$�@���������[�a�������ߑ +�����!����� ��P���t�.`���;�����Y|L��6�� @������<�`�:���u�|0"CAdHq$J�(d1�X������'�3O�>%
�P��K>�r¿�G��/p��� �/�����;G@��ЇO��v�8�E�J���Kn���4�fSi�&ei2x�k�=ҡ�U����yE��S�a/�ݸ#[�,w�{5�]��6�٩�B��c�|U
�`{3�hw�#W�ǜ۫��I���Kw��u[tL��\��ݱ�պd��s�2կ��͗*��c���,���N}�?�������?|�?�0���	��C�W~g���;��V7����5����X�M�ѩS=��
�>dGy�/�����2g�̭S�m���v;6��|�٣��$���7��@*Ʀ�wJ��TO���P�7퍩�[�.�9�4���YN�c�� �{-���o�C�0��C��p�7^�?8�A�Wq��/����/�����b�?�� ����������x���ZW������W=F��[~��t���>������n����.�NS<ūR�`v_���c�Mw;[w�rI�Ϥ�:��:H���l���Fa�i�j3��d'e����4��T>�2i3bR�:N�	�fOl����Ԭ�r�V����+}���.�z���݊����^�*�^Q��;y*�ċ�-ڗk�$i�Vu�S�@�Nٶ+�Eb�"aZ��J-�m����l�jԄC�n$�i*f"FF��=bqh����I�js�5�btC-���2�(�ͳR$��*Y�\)�m�Yy�\s������+�N�_m�x�|x��<��I���+���H���|��+�������G�?����	��H������J�����u�gI��G��&���_������'xz�T��S��y����<��P����UU9:~��0���^/agR�Ҍ�>cޜ�����?*��<������U^}ȸi�_�tV:'�:�ì�ה�ֹO)?�k�������7Ϟ�.}SI�R��K�򒹼���ږ��rWI��L��|ͺ���_
�����^�Pץ��;m�hs�y�K[�J�ֺ�ʣ>-�=�1Z?��kʟ˒3�ʜ�5)����7�2��O�4ޮ(1t����xM�]�o���8w~^�\I���gY��Oi?�����%�V6��=i�=QTEp���))�fy������N��r��JӘ>�ږ���Y�>�2'VM�]�(��9qD�J�:g��E���u��@:����`�4S+���2q˾�;�!��An*�!�O���5v~�z^ؗ��6o�o��	X�?������x��a$R,�K#&����,J#��I��B�e���r!��dHE���Q�!����?�?��C��Y����H�y��hO�y@�m����񧻸~�6g�"z�)�c���\�V�o�+�����G?������K���%0���H������@��/�����?����k�.�?�k����}��N���?Z����(����]���0�<��9w��]l��r�/�~�{r������Tܧ�_�)����#^����I��l�DUjW���+mV۲��v���×�A���@@p����@&D@Q+�7\��7S�2++/P�^�D8�:k���:�R��=C\���#����❮��ڼQv\��p��N���z�Kqt\�lX5��+*�#��$�C�u��:���S5��:�Z;6�2?)3L�J�+[�S}.������3�D�����8�{3I�G��u'862f��u���(��z�H39k[�n|,��M�9ϰɍQ^��T^)$����N2c��q�+����{�?P��	2��)��Iݠ�U��U�Hg�t:yE1�aj��jU�b�=��*N*�S��Z����"���Ϗ�U���@��=����ؠ]_�H��co�k���4�GrX=���?Ҽ�p^��~_����V��_��~�S��o�c���@�_��n��/d���i�/��XH ��������2���LY����`7�?�C��	�4�ç�ڇ��s���o�[-�������?����a����C��u�3;���Xw;��D�0Ađ��H����Sg%�:�����&��˶��m�d%��3WȷN]]g���+W������X\k�;/}������TΫe:S�,u�k������ɢ�����i�����}cz�u�-#Z�wQ�)Z����U~�F��w�N[�Xxl��/�?
���6���˼ϊ����e��{lS[��#eKl��ܗ���kZ���-���;yb�Ҿ��&'�e�m���>��i11��t=/}A2�*���n���`�:�U�U�!�k���Ú�w�#aX���1��Զ��d����"�?���ߐ��	���u�������E�X�)?d���Z<"����d�����	����	��0������p($ �l�W������1��\�P�����-���� ����������A��E�Y�+������|�Ob�g�B�?s����!��I���  ��ϟ������o&ȋ��q��� ���?��M���������������?yg��?���"'d����!��� ������؝�_���y�?(
��?��+�Wn� �##���"$?"���H��2�?���?�������Z��/D������_!���sCA�|!rB!������a�?���?���?�;����2A��/t,H���?��+��w� �+��!�?/"����� ��������B�?��������[�0��������E��
~���������Ve����H����Y#R7եY�R��T\'i�4����H�aL��h�}�V?�E��
}�C�6x���$	�JMa~���k	l�kK�i'�d-�[���ױ��$,Vӱ�~ߢ�k��~�k�?G�C�T�oLM���'Vt��m���t����A����L��ݸ�K=vI|�F:��TH��U�JkO�=K"�8i�Uf���Y�ʛ'����X�W�����M���C����y���f}��"����"�?���<���OI�w+<.�������q��&��8�St�aH�4�qM7�iܱ�ͼ�3�H\�����5�ɺ��tGkWӃ� ۉ���F.��{$!�pr�T��a�g:�����x���H�N��^�V��S��Z
,�Ň�<�!��Z�����oNȳ���'=��o�B�A�Wn��/����/�����9������}��*8�,�E��g������+
D?����,OI������?q�����K�s"��p_[s��@n��`�z���d�ko�>�aTw��N{�1�NUm��jެ�T9�8-��xZ�1!f.�sy��I�fn���b�ިK����}�6�A��+����,yQg�t����m�]>k��X�|MV�Y�����s�B<����~�u�Y�.Er��� ���-(uֱ�R�|�+�''�Od���������.�f�P�n-������l�:r��	<"��S9�M��;�vuL��	�I�#M�]]��n㨲����^�����)/�u��r ${Y|�_���n�?*L��	�o�B�?s��������ˋ��'��������n�?�P��Y W�O���n��?����ߩ���L�;��Z<�xD ����������E�p��Y����L�����, ��������B�?���/�L���� s�����
����Cn(��򏹠�?}[��A�G&�b��9��P?��Q����㦧��f���o�?�Q��z,�_�?b��#-�@���w�\��~�Wj?���+jgmn|���^�~�������+N4l��3.6�=��J���q�Gjt���˚�w�.&k�F�q���i�:��f�/��qA�a՜�g��X��+����ֺ�k�/r��WՄ��p,j9�ؔ����0�*mw�lO��8��SV���l�_��:3���$�cם��Ș1�z�����Q���8֑frֶ���Xد�8js�a���8x���RHT�ۛ!�d�^?΀A!������߫E��n�G�����
��0������/a S"�������& �/���/���7�'a�''��>.�wS<$ �l�W��0���P ��s �5
�C�n�R�_��������t�l�;r<�:Q:֨=�P��������X������6�;9]��� y��C@������=��v�*�U����,~wؖ�y�pWS!���a[��'m�veb��.:�������XkB�~ ��� $-���A��V���Mٮ	>��e�P�VKېhOA�;fe[k�s�jZ��9*��i8V��;{P��JG�8$��˚9���X��>��fB��w���L�����x�-�����_������ �g���?Y#]�0�I��Z��Ʋ�i�IaMj8E��Uk��&�2�iR��1�Q�2Ē�߇o����Q����'��g����Y0C���Zk��32�����j2��Š��kјG��u��S���h�`�u?P� �:���z�A�5%ǶoUT�s8,�\u���<�)�s���r�@�L0̀�� ���V�h�~-�����g~ȵ�O�ʻE��!�����������"�I�wS<$����������fj�D�')�Đ:�&���x�N+;D��\�D��5�����ڍG;���:�l�=r��1�jN)ďNCaBͰʄ��]�:�y_i�bD]I�I��ho���oBsv�H⿯E1����/*����=r��u �������� �_P��_P��?��������(��/'|I�MS�g��_��}z�z&J���4�0�&��o��^j ����� ������
��F�����˼��eŌ���٫���EcR���|�!k���U&:��p�l��Uʵ�y��VS�CEk��E���r�ϭϟ�<$�y��ƍ�����Un�s��l��	���\��?�@�8O$׏Z�_�J^4֔� �zĺ��3���}��bD��y���Ul�Q�Y/f�Fw�O��\n|ط���ό9�8MX�ہ�0:����D:{���b̞6���1G�6����BH��G�P�E-�>�ӃМ��5����^�װ��`���oo�h����):~]�����D�}��IW(��,p��-�+%��@��һ�����O;����&�z��ATYn ��yQz�cG�_~�M���蘞�lMgc���_N�"��cB',���#q���.=}�}��.���t����U�36�S�\������I����[������-�|@�_���OI$>�y
�?�_���)��矠��x����Ts<TSCA�Q�NT�z%�	¨d�6�w�/*��M�ĸ����ЈJ�C�)P�Rd%}Fr��	=�'�.~�����e)�/�ᩮ����c�����x�����o?����?�Y��e�*9+���_���Ӈ�A�	)���eC�y{��1O'wSZnc�[߻�K��}�j�6�6(5N�l��e��#Q����'$9��t59�ּ4_X�턼���9�U�$|h���0��OIu8b��#�-tǣ_�{��'y{W3��A�ޖ~��ޱ�!��0��ݛ\݅$/_��]�9�C/��`O���_�ϛ�Ǘ��)�mKwb��b0
KH�srM�5"�?6ze�{D�^��u�߻���_���'w�.���݁�'���a��vDYz�n."-B؇)�]�����~���Y���N���_�����>==d?   �b��+� � � 