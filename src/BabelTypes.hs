{-# LANGUAGE OverloadedStrings #-}
module BabelTypes (
  Lang (..)
  , ParseException (..)
  , TwilioCredentials (..)
  , GoogleKey (..)
  , GoogleTranslation (..)
  , GoogleTranslateResult (..)
) where

import Control.Applicative

import Data.Aeson
import Data.Functor
import qualified Data.Text as T

import Control.Monad

data Lang = Lang {
  lang_Name :: T.Text
  , lang_Code :: T.Text
} deriving Show

data ParseException = BadFormat | UnknownLanguage deriving Show

data TwilioCredentials = TwilioCredentials {
  twilio_accountSid :: T.Text
  , twilio_authToken :: T.Text
} deriving Show

newtype GoogleKey = GoogleKey { getGoogleKey :: T.Text } deriving Show

data GoogleTranslation = GoogleTranslation {
  gtr_DetectedSourceLanguage :: T.Text
  , gtr_Translation :: T.Text
} deriving Show

newtype GoogleTranslateResult = GoogleTranslateResult { getGoogleTranslations :: [GoogleTranslation] } deriving Show

instance FromJSON GoogleTranslation where
  parseJSON (Object v) =
    GoogleTranslation <$>
      v .: "detectedSourceLanguage" <*>
      v .: "translatedText"
  parseJSON _ = mzero

instance FromJSON GoogleTranslateResult where
  parseJSON (Object v) = do
    dataNode <- v .: "data"
    GoogleTranslateResult <$> dataNode .: "translations"
  parseJSON _ = mzero
