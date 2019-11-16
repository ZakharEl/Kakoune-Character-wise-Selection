define-command -hidden character-wise-insert %{
	execute-keys %sh{
		echo "$kak_reg_dquote" | awk 'BEGIN{RS="<";ORS="<lt>"}{gsub(/>/,"<gt>");gsub(/\t/,"<tab>");gsub(/\n/,"<ret>");print}' | sed -e 's/<ret><lt>$//'
	}
}
define-command character-wise-paste-before %{
	evaluate-commands -draft %{
		execute-keys i
		character-wise-insert
	}
}
define-command character-wise-paste-after %{
	evaluate-commands -draft %{
		execute-keys a
		character-wise-insert
	}
}
define-command character-wise-paste-sel-before %{
	execute-keys ii<esc>ha
	character-wise-insert
	execute-keys -draft '<esc><a-;>;d'
	execute-keys <esc>
}
define-command character-wise-paste-sel-after %{
	execute-keys '<a-:>;a'
	character-wise-insert
	execute-keys <esc>
	execute-keys %sh{
		if [ "$kak_selection" == "$kak_reg_dquote" ]
		then
			exit
		fi
		printf '<a-;>L<a-;>'
	}
}
declare-option bool character_wise
hook global GlobalSetOption character_wise=true|yes %{
	map global normal p ': character-wise-paste-after<ret>'
	map global normal P ': character-wise-paste-before<ret>'
	map global normal <a-p> ': character-wise-paste-sel-after<ret>'
	map global normal <a-P> ': character-wise-paste-sel-before<ret>'
}
hook global GlobalSetOption character_wise=false|no %{
	unmap global normal p ': character-wise-paste-after<ret>'
	unmap global normal P ': character-wise-paste-before<ret>'
	unmap global normal <a-p> ': character-wise-paste-sel-after<ret>'
	unmap global normal <a-P> ': character-wise-paste-sel-before<ret>'
}
map global normal <c-p> ': set-option global character_wise true<ret>'
map global normal <c-P> ': set-option global character_wise false<ret>'
