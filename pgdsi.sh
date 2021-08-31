# Copyright 2021 Japannext Co., Ltd. <https://www.japannext.co.jp/>
# SPDX-License-Identifier: Apache-2.0

readonly DBRS="	"

dbtool() {
	eval local dbtool=\$${name}_dbtool
	eval local dbspec=\$${name}_dbspec
	local query=$1
	$dbtool $dbspec -X -Atq << __EOF__
		\f '$DBRS'
		$query
__EOF__
}

emit_shstyle_header() {
	cat << __EOF__
#
# This file was automatically generated.
# Please DO NOT MODIFY THIS FILE, modify content of the config DB instead.
#
__EOF__
}
