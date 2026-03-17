EAPI=8
inherit acct-user
DESCRIPTION="User for Ollama"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( ollama )
ACCT_USER_HOME="/var/lib/ollama"
ACCT_USER_HOME_PERMS="0755"
