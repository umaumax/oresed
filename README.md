# oresed

## how to use
```
PATH=".:$PATH"

echo '#!/usr/bin/env bash' | oresed fixedsed_src
echo '#!/usr/bin/env bash' | oresed fixedsed_src_E
echo '#!/usr/bin/env bash' | oresed fixedsed_dst

echo '#!/usr/bin/env bash' | oresed fixedsed   '#!/usr/bin/env bash' '#!/usr/bin/env zsh'
echo '#!/usr/bin/env bash' | oresed fixedsed_E '#!/usr/bin/env bash' '#!/usr/bin/env zsh'
```

## how to run test
```
PATH=".:$PATH"

ORESED_DEBUG=1 oresed test
```
