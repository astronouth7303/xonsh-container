# Baseline stuff for actions

import json

$GITHUB_EVENT = json.loads(p"$GITHUB_EVENT_PATH".read_text())

$INPUT = {
    k[len('INPUT_'):]: v
    for k, v in ${...}.items()
    if k.startswith('INPUT_')
}


# Set up a GitHub API client, based on what's installed.
# Supported:
# - PyGithub
# - gqlmod-github

if 'GITHUB_TOKEN' in $INPUT:
    token = $INPUT['GITHUB_TOKEN']
elif 'GITHUB_TOKEN' in ${...}:
    token = $GITHUB_TOKEN
else:
    token = None


if token is not None:
    try:
        import github
    except ImportError:
        pass
    else:
        $GITHUB = github.Github(token)

    try:
        import gqlmod
    except ImportError:
        pass
    else:
        gqlmod.enable_gql_import()
        cm = gqlmod.with_provider('github', token=token)
        cm.__enter__()
        # This is only to avoid warnings at exit
        events.on_exit(cm.__exit__)
        del cm

del token
