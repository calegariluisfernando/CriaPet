<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Ramsey\Uuid\Uuid;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'apelido',
        'email',
        'password',
        'uuid',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function (User $user) {

            $user->name = trim($user->name);
            $user->apelido = trim($user->apelido);

            if (empty($user->apelido)) {
                $user->apelido = explode(' ', $user->name)[0];
            }
            $user->uuid = Uuid::uuid4();
        });
    }

    public function photo()
    {
        return $this->hasOne(UserPhoto::class);
    }

    public function animais()
    {
        return $this->belongsToMany(Animal::class, 'UserAnimal', 'user_id', 'animal_id')
            ->withPivot(['isDono', 'created_at', 'updated_at']);
    }
}
