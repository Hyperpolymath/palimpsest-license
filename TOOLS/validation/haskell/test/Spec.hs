module Main where

import Test.Hspec
import Palimpsest.Validator.LicenseSpec
import Palimpsest.Validator.MetadataSpec
import Palimpsest.Validator.BilingualSpec

main :: IO ()
main = hspec $ do
  describe "Palimpsest Validator Test Suite" $ do
    licenseSpec
    metadataSpec
    bilingualSpec
