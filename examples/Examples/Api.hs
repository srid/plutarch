module Examples.Api (tests) where

import Plutarch
import Plutarch.Builtin (PAsData, pfromData )
import Data.Proxy (Proxy (..))
import Plutarch.DataRepr (pindexDataList)
import Plutarch.Api.V1 
  (PScriptContext (..), PTxInfo (..), PValue (..))

import Plutus.V1.Ledger.Api 
  (ScriptContext (..), Value, TxOut (..), TxInInfo (..), Address (..)
  , TxOut (..)
  , TxOutRef (..)
  , Credential (..)
  , TxInfo (..)
  , ScriptPurpose (..)
  , ValidatorHash
  , CurrencySymbol
  , DatumHash
  )
import qualified Plutus.V1.Ledger.Interval as Interval
import qualified Plutus.V1.Ledger.Value as Value
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (testCase, (@?=))

import Utils

--------------------------------------------------------------------------------

{- | 
  An example 'PScriptContext' Term, 
  lifted with 'pconstant'
-}
ctx :: Term s PScriptContext
ctx = 
  pconstant 
    (ScriptContext info purpose)

-- | Simple script context, with minting and a single input
info :: TxInfo
info =
  TxInfo
    { txInfoInputs = [inp]
    , txInfoOutputs = []
    , txInfoFee = mempty
    , txInfoMint = mint
    , txInfoDCert = []
    , txInfoWdrl = []
    , txInfoValidRange = Interval.always
    , txInfoSignatories = []
    , txInfoData = []
    , txInfoId = "b0"
    }

-- | A script input
inp :: TxInInfo
inp  =
  TxInInfo
    { txInInfoOutRef = ref 
    , txInInfoResolved = 
        TxOut
          { txOutAddress = 
              Address (ScriptCredential validator) Nothing 
          , txOutValue = mempty
          , txOutDatumHash = Just datum
          }
    }

-- | Minting a single token
mint :: Value
mint = Value.singleton sym "sometoken" 1

ref :: TxOutRef 
ref  = TxOutRef "a0" 0

purpose :: ScriptPurpose
purpose = Spending ref

validator :: ValidatorHash
validator = "a1"

datum :: DatumHash
datum = "d0"

sym :: CurrencySymbol
sym = "c0"

--------------------------------------------------------------------------------

getTxInfo :: Term s (PScriptContext :--> PAsData PTxInfo)
getTxInfo =
  plam $ \x -> pmatch x $ \case 
    (PScriptContext c) -> pindexDataList (Proxy @0) # c


getMint :: Term s (PAsData PTxInfo :--> PAsData PValue)
getMint =
  plam $ \x -> pmatch (pfromData x) $ \case 
    (PTxInfo c) -> pindexDataList (Proxy @3) # c

tests :: TestTree
tests =
  testGroup
    "Api examples"
    [ testCase "ScriptContext" $ do
        ctx `equal'` ctx_compiled
    , testCase "getting txInfo" $ do
        plift (getTxInfo # ctx) @?= info
    , testCase "getting mint" $ do
        plift (getMint #$ getTxInfo # ctx) @?= mint
    , testCase "lift value" $ do
        plift (pconstant @PValue mint) @?= mint
    ]

ctx_compiled :: String 
ctx_compiled = "(program 1.0.0 #d8799fd8799f9fd8799fd8799fd8799f41a0ff00ffd8799fd8799fd87a9f41a1ffd87a80ffa0d8799f41d0ffffffff80a0a141c0a149736f6d65746f6b656e018080d8799fd8799fd87980d87a80ffd8799fd87b80d87a80ffff8080d8799f41b0ffffd87a9fd8799fd8799f41a0ff00ffffff)"