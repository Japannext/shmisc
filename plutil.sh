plist_get() {
	local file=$1
	local key=$2
	awk '
		function curkey(rs) {
			for (i = 0; i++ < n;)
				rs = rs sprintf("/%s",kn[i])
			return rs
		}
		/<dict>/ {n++}
		/<\/dict>/ {n--}
		/<key>/ {
			gsub(/[\t ]*<\/*\w+>[\t ]*/,"");
			kn[n]=$0
		}
		/<(string|real|integer|date)>/ {
			if (curkey() == key) {
				gsub(/[\t ]*<\/*\w+>[\t ]*/,"");
				print
			}
		}
		/<(true|false) *\/>/ {
			if (curkey() == key) {
				gsub(/[\t<\/>\t ]*/,"");
				print
			}
		}
	' key=$key $file
}
