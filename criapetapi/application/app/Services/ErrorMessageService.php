<?php

namespace App\Services;

use Exception;

class ErrorMessageService
{
    public static function handleException(Exception $exception): string
    {
        if (app()->environment('local', 'development')) {
            return $exception->getMessage();
        } else {
            return 'Erro Interno';
        }
    }
}
