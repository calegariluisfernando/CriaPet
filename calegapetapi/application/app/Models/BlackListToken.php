<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BlackListToken extends Model
{
    use HasFactory;
    protected $table = 'BlackListToken';
    protected $fillable = ['token'];
}
