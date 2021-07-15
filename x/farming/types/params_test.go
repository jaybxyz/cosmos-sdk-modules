package types_test

import (
	"testing"

	paramstypes "github.com/cosmos/cosmos-sdk/x/params/types"
	"github.com/kogisin/cosmos-sdk-modules/x/farming/types"
	"github.com/stretchr/testify/require"
)

func TestParams(t *testing.T) {
	require.IsType(t, paramstypes.KeyTable{}, types.ParamKeyTable())

	defaultParams := types.DefaultParams()

	paramsStr := `private_plan_creation_fee:
- denom: stake
  amount: "100000000"
`
	require.Equal(t, paramsStr, defaultParams.String())
}
