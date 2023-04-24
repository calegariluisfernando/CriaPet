<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BlackListToken extends Model
{
    protected $table = 'blacklist_tokens';
    protected $fillable = ['token'];
}
