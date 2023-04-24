<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TokenAtivo extends Model
{
    protected $table = 'tokens_ativos';
    protected $fillable = [
        'user_id',
        'token',
    ];
}
