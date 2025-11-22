{-# LANGUAGE OverloadedStrings #-}

module Palimpsest.Validator.BilingualSpec (bilingualSpec) where

import Test.Hspec
import Data.Text (Text)
import Palimpsest.Validator.Bilingual

bilingualSpec :: Spec
bilingualSpec = describe "Bilingual Validator" $ do
  describe "Title matching" $ do
    it "matches identical titles" $ do
      titleMatches "Definitions" "Definitions" `shouldBe` True

    it "matches with minor formatting differences" $ do
      titleMatches "Attribution Options" "Attribution Options:" `shouldBe` True
      titleMatches "Clause 1 — Definitions" "Definitions" `shouldBe` True

    it "is case-insensitive" $ do
      titleMatches "DEFINITIONS" "definitions" `shouldBe` True

  describe "Bilingual map parsing" $ do
    it "parses markdown table rows" $ do
      let row = "| 1 | Definitions | Definities |"
      case parseTableRow row of
        Just mapping -> do
          mappingClauseNumber mapping `shouldBe` "1"
          mappingEnglishTitle mapping `shouldBe` "Definitions"
          mappingDutchTitle mapping `shouldBe` "Definities"
        Nothing -> expectationFailure "Failed to parse valid table row"

    it "skips header rows" $ do
      let header = "| Clause No. | English | Dutch |"
      parseTableRow header `shouldBe` Nothing
